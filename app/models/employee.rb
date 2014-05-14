# encoding: UTF-8
class Employee < ActiveRecord::Base
  belongs_to :person

  belongs_to :occupational_group

  has_many :payments
  has_many :commutes
  has_many :vacations
  has_many :expense_reports
  has_many :payrolls

  has_many :attachment
  has_many :except_columns
  has_many :change_histories

  has_many :project_infos, class_name: "ProjectAssignInfo", as: :participant
  has_many :projects, through: :project_infos

  has_many :documents

  has_many :assets, foreign_key: 'owner_id'

  serialize :employment_proof_hash, Array

  include Historiable
  include Attachmentable
  include EmploymentProof
  
  belongs_to :bankbook
  delegate :name, :to => :bankbook, prefix: true, allow_nil: true

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('employees.error.juminno_invalid')
  validates_uniqueness_of :juminno
  validates_uniqueness_of :companyno
  validate :can_connect_with_only_no_employee_account, on: :create

  attr_accessor :email, :phone_number, :address, :contact_id

  before_save :find_contact_and_connect_account
  def find_contact_and_connect_account
    if self.contact_id
      contact = Contact.find(self.contact_id.to_i)
      if contact.person
        account = Account.find_by_person_id(self.person.id)
        self.person = contact.person
        self.person.account = account
        account.save!
      else
        self.person.contact = contact
      end
      contact.save!
    end
  end

  SEARCH_TYPE = {
    I18n.t('models.employee.join') => :join,
    I18n.t('models.employee.retire') => :retire
  }

  scope :classified, lambda { |controller_name|
    joins(occupational_group: :employee_classifications).
    where("employee_classifications.name = ?", controller_name)
  }

  class << self
    def find_by_account_name(account_name)
      joins(:person => :account).merge(Account.where(name: account_name)).first
    end

    def search(person, type, text)
      text = "%#{text}%"
      raw_join = "INNER JOIN people ON people.id = employees.person_id " +
                 "INNER JOIN contacts ON contacts.person_id = people.id "
      search_by_type(person, type).search_by_text(text) |
      search_by_type(person, type).search_contact_by_text(text) |
      search_by_type(person, type).search_contact_email_by_text(raw_join, text) |
      search_by_type(person, type).search_contact_phone_number_by_text(raw_join, text) |
      search_by_type(person, type).search_contact_address_by_text(raw_join, text)
    end

    def search_by_type(person, type)
      type = type.to_sym

      if person and person.admin? and type == :retire
        where('employees.retired_on IS NOT NULL')
      else
        where('employees.joined_on IS NOT NULL AND employees.retired_on IS NULL')
      end
    end

    def search_by_text(text)
      joins(:person => :account).where('accounts.name LIKE ? OR accounts.notify_email LIKE ?', text, text)
    end

    def search_contact_by_text(text)
      query = Contact.search_by_name_query + " OR contacts.company_name LIKE ? OR contacts.department LIKE ? OR contacts.position LIKE ?"
      joins(:person => :contact).where(query, text, text, text, text)
      # joins(:person => :contact).merge(Contact.search(text)) # It seems to be good choice. So i remain this code.
    end 

    def search_contact_email_by_text(join, text)
      join += "INNER JOIN contact_emails ON contact_emails.contact_id = contacts.id"
      joins(join).where("contact_emails.email LIKE ?", text)
    end

    def search_contact_phone_number_by_text(join, text)
      join += "INNER JOIN contact_phone_numbers ON contact_phone_numbers.contact_id = contacts.id"
      joins(join).where("contact_phone_numbers.number LIKE ?", text)
    end

    def search_contact_address_by_text(join, text)
      join += "INNER JOIN contact_addresses ON contact_addresses.contact_id = contacts.id"
      joins(join).where("contact_addresses.country like ? OR
                        contact_addresses.province like ? OR
                        contact_addresses.city like ? OR
                        contact_addresses.other1 like ? OR
                        contact_addresses.other2 like ? OR
                        contact_addresses.postal_code like ?", text, text, text, text, text, text)
    end

    def payment_in?(from, to)
      select{|employee| employee.payments.payment_in?(from, to).total > 0 }
    end

    def not_retired
      where(retired_on: nil)
    end

    def enabled
      joins(:person => :account).merge(Account.enabled)
    end

    def with_account
      joins(:person => :account).where('employees.person_id = people.id')
    end
  end

  def related_projects
    types = [:employees, :groups]
    groups = [self.id] + person.groups.map{|group| group.id}

    Project
      .includes(:assign_infos)
      .merge(ProjectAssignInfo.projects_by_participant([:employees, :groups], [self.id] + person.groups.map{|group| group.id}))
  end

  def admin?
    person.admin?
  end

  def joined?
    joined_on
  end

  def not_joined?
    not joined?
  end

  def retired?
    retired_on?
  end

  def position
    person.contact.position rescue ""
  end

  def department
    person.contact.department rescue ""
  end

  def firstname
    person.contact.firstname rescue ""
  end

  def lastname
    person.contact.lastname rescue ""
  end

  def fullname
    lastname + " " + firstname rescue ""
  end

  def name
    fullname
  end

  def email
    person.contact.emails.first.email rescue ""
  end

  def phone_number
    person.contact.phone_numbers.first.number rescue " "
  end

  def address
    person.contact.addresses.first.info rescue ""
  end

  def retire!
    payments.retire!(retired_on)
    save!
  end

  def company
    Company.first
  end

  def work_from
    joined_on
  end

  def work_to
    retired_on || Time.zone.now
  end

  def project_owner?(project)
    self.project_infos.find_by_project_id(project).owner
  end

  def apply_status
    case report.status
    when :rollback
      I18n.t('models.employee.request')
    else
      I18n.t('models.employee.approve')
    end
  end

  private
  def can_connect_with_only_no_employee_account
    unless Person.no_employee.map {|p| p.id}.include? person_id
      errors.add(:person_id, I18n.t('activerecord.errors.models.employee.attributes.person_id.taken'))
    end
  end
end
