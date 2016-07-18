class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.belongs_to :project
      t.attachment :image
      t.integer :place_count_height
      t.integer :place_count_width
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
