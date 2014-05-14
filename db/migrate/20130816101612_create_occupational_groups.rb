class CreateOccupationalGroups < ActiveRecord::Migration
  def change
    create_table :occupational_groups do |t|
      t.string :name

      t.timestamps
    end
    add_index :occupational_groups, :name, :unique => true
  end
end
