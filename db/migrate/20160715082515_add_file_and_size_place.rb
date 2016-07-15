class AddFileAndSizePlace < ActiveRecord::Migration
  def change
    add_attachment :projects, :image
    add_column :projects, :size_place_x, :integer
    add_column :projects, :size_place_y, :integer
  end
end
