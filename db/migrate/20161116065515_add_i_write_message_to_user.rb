class AddIWriteMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :i_write, :boolean, default: false
  end
end
