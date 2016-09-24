class AddSizeRegionToProject < ActiveRecord::Migration
  def change
    add_column :projects, :region_height, :integer
    add_column :projects, :region_width,  :integer
    add_column :projects, :count_places_in_line_regions, :integer
  end
end
