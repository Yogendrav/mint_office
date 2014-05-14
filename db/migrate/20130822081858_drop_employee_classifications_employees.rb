class DropEmployeeClassificationsEmployees < ActiveRecord::Migration
  def up
    remove_index :employee_classifications_employees, name: :employee_classifications_employees_index
    drop_table :employee_classifications_employees
  end

  def down
    create_table :employee_classifications_employees, id: false do |t|
      t.references :employee, null: false
      t.references :employee_classification, null: false
    end

    add_index(:employee_classifications_employees,
      [:employee_id, :employee_classification_id],
      unique: true,
      name: :employee_classifications_employees_index)
  end
end
