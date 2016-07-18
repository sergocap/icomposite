class AddRpeviewToRegionAndProject < ActiveRecord::Migration
  def change
    add_attachment :projects, :preview
    add_attachment :regions, :preview
  end
end
