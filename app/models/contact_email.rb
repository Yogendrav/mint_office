class ContactEmail < ActiveRecord::Base
  belongs_to :contact
  has_and_belongs_to_many :tags, :class_name => 'ContactEmailTag'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
  after_update {|model| model.blank_if_destroy}
  before_save do
    tag = ContactEmailTag.find_by_name(target)
    tags << tag if tag.present? and !tags.exists?(name: tag.name)
  end

  include Historiable
  def history_parent
    contact
  end
  def history_except
    [:target, :contact_id]
  end
  def history_info
    {
      :email => proc { |email, v| "[#{email.target}]#{v}" }
    }
  end

  def self.search(query)
    where("contact_emails.email like ?", query)
  end

  def serializable_hash(options={})
    super(options.merge(only: [:id, :email, :target]))
  end

  def target_view
    target ? "(#{target})" : ""
  end

  def all_blank?
    email.blank?
  end

  def blank_if_destroy
    destroy if all_blank?
  end
end