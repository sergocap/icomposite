class CreateCompleteProjectStorages < ActiveRecord::Migration
  def change
    create_table :complete_project_storages do |t|
      t.text :data_medium
      t.text :data_full_size
      t.belongs_to :project

      t.timestamps null: false
    end
  end
end
