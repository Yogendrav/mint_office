class AddCommentToCommutes < ActiveRecord::Migration
  def change
  	 add_column :commutes, :comment, :text
  end
end
