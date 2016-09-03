class CreatePlaceOriginalImages < ActiveRecord::Migration
  def change
    create_table :place_original_images do |t|
      t.attachment :image
      t.integer :x
      t.integer :y
      t.belongs_to :region

      t.timestamps
    end
  end
end
