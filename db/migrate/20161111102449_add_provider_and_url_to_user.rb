class AddProviderAndUrlToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :url, :string
  end
end
