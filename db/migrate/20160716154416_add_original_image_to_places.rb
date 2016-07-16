class AddOriginalImageToPlaces < ActiveRecord::Migration
  def change
    add_attachment :places, :original_image
  end
end
