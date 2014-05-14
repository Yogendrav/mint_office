# encoding: UTF-8
class ChangeDayworkerIdToEmployeeIdToDayworkerTaxes < ActiveRecord::Migration
  def up
    add_column :dayworker_taxes, :employee_id, :integer

    account_index = 0
    companyno = Employee.maximum(:companyno)
    Company.current_company = Company.first
    Dayworker.all.each do |dayworker|
      if (employee = dayworker.person.employee).present?
      elsif (employee = Employee.where(juminno: dayworker.juminno).first).present?
      else
        employee = Employee.new(dayworker.attributes)
        employee.companyno = companyno += 1
        employee.joined_on = Date.today
        employee.occupational_group = OccupationalGroup.find_or_create_by_name "프리랜서"
        employee.save!

        while Account.exists?(name: "dayworker_#{account_index}")
          account_index += 1
        end

        account = Account.new(name: "dayworker_#{account_index}", password: '1234')
        account.person = employee.person
        account.save!
        puts "The account's name is '#{account.name}'"
      end

      DayworkerTax.where(dayworker_id: dayworker.id).each do |tax|
        tax.employee_id = employee.id
        tax.save!
      end
    end
    # remove_column :dayworker_taxes, :dayworker_id
  end

  def down
    # add_column :dayworker_taxes, :dayworker_id, :integer

    remove_column :dayworker_taxes, :employee_id
  end
end
