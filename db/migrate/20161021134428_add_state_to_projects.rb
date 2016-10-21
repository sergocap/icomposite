class AddStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :state, :string, default: 'development'
    add_column :projects, :height, :integer
    add_column :projects, :width, :integer
    add_column :regions, :height, :integer
    add_column :regions, :width, :integer
    add_column :places, :project_id, :integer, index: true
    remove_column :projects, :region_height
    remove_column :projects, :region_width
  end
end
