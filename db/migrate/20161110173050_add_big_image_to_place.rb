class AddBigImageToPlace < ActiveRecord::Migration
  def change
    add_attachment :places, :big_image
  end
end
