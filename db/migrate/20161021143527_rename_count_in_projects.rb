class RenameCountInProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :count_places_in_line_regions, :standart_K
  end
end
