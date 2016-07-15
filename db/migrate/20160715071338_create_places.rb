class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.attachment :image
      t.integer :x
      t.integer :y
      t.string  :status
      t.belongs_to :project, index: true
      t.timestamps
    end
  end
end
