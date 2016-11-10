class AddCommentToPlace < ActiveRecord::Migration
  def change
    add_column :places, :comment, :string
  end
end
