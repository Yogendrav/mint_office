class OccupationalGroup < ActiveRecord::Base
	has_many :employees
  has_and_belongs_to_many :employee_classifications

  attr_accessible :name

  scope :classified, lambda { |controller_name|
    joins(:employee_classifications).
    where("employee_classifications.name = ?", controller_name)
  }

end
