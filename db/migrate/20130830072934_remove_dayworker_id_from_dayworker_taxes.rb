class RemoveDayworkerIdFromDayworkerTaxes < ActiveRecord::Migration
  def up
    remove_column :dayworker_taxes, :dayworker_id

    drop_table :dayworkers
  end

  def down
    create_table :dayworkers, :force => true do |t|
      t.string   :juminno
      t.integer  :person_id
      t.integer  :bankbook_id

      t.timestamps
    end

    add_column :dayworker_taxes, :dayworker_id, :integer
  end
end
