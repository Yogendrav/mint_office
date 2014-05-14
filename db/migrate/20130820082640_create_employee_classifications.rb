class CreateEmployeeClassifications < ActiveRecord::Migration
  def change
    create_table :employee_classifications do |t|
      t.string :name

      t.timestamps
    end

    create_table :employee_classifications_employees, id: false do |t|
      t.references :employee, null: false
      t.references :employee_classification, null: false
    end

    add_index(:employee_classifications_employees,
      [:employee_id, :employee_classification_id],
      unique: true,
      name: :employee_classifications_employees_index)

    create_table :employee_classifications_occupational_groups, id: false do |t|
      t.references :occupational_group, null: false
      t.references :employee_classification, null: false
    end

    add_index(:employee_classifications_occupational_groups,
      [:occupational_group_id, :employee_classification_id],
      unique: true,
      name: :employee_classifications_occupational_groups_index)
  end
end
