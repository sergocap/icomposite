class AddSizeToImagePlace < ActiveRecord::Migration
  def change
    add_column :places, :image_height, :integer
    add_column :places, :image_width, :integer
  end
end
