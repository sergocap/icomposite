class CleanBase < ActiveRecord::Migration
  def change
    remove_attachment :places, :original_image
    remove_column     :places, :status
    remove_column     :regions, :place_count_height
    remove_column     :regions, :place_count_width
  end
end
