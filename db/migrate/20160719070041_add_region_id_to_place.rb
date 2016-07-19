class AddRegionIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :region_id, :integer, :index => true
  end
end
