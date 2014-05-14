class AddIndexesToPolymorphicModels < ActiveRecord::Migration
  def change
    add_index :reports, [:target_id, :target_type]
    add_index :reports, :status

    add_index :report_people, :report_id
    add_index :report_people, :person_id
    add_index :report_people, :owner

    add_index :taggings, [:target_id, :target_type]
    add_index :taggings, :tag_id
    
    add_index :access_people, [:access_target_id, :access_target_type]

    add_index :documents, :company_id
  end
end
