class RemoveProjectIdFromPlace < ActiveRecord::Migration
  def change
    remove_column :places, :project_id
  end
end
