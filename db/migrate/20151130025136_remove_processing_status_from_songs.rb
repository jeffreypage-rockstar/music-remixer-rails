class RemoveProcessingStatusFromSongs < ActiveRecord::Migration
  def change
    remove_column :songs, :processing_status
  end
end
