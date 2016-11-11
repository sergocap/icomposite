class AddAboutMyToUser < ActiveRecord::Migration
  def change
    add_column :users, :about_my, :text
  end
end
