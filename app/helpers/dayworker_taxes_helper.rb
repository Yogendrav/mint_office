# encoding: UTF-8

module DayworkerTaxesHelper
  def options_for_employees_select_by_dayworker_taxes(dayworker_tax)
    id = dayworker_tax.employee ? dayworker_tax.employee.id : nil
    collection = Employee.classified(controller_name).not_retired.map do |employee|
      contact = employee.person.contact
      if contact
        description = "#{contact.name} - "
      end

      description += employee.juminno
      [description, employee.id]
    end

    options_for_select(collection, id)
  end
end