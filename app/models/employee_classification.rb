class EmployeeClassification < ActiveRecord::Base
  has_and_belongs_to_many :occupational_groups

  validates :name, presence: true, uniqueness: true

  def self.applied_controller_list
    [
      "vacations",
      "payments",
      "commutes",
      "dayworker_taxes"
    ]
  end

  def to_param
    name
  end
end
