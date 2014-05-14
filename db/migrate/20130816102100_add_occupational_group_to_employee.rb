class AddOccupationalGroupToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :occupational_group_id, :integer
  end
end
