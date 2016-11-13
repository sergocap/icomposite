class AddSmallImageToPlace < ActiveRecord::Migration
  def change
    add_attachment :places, :small_image
  end
end
