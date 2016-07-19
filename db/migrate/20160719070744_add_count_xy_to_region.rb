class AddCountXyToRegion < ActiveRecord::Migration
  def change
    add_column :regions, :count_x, :integer
    add_column :regions, :count_y, :integer
  end
end
