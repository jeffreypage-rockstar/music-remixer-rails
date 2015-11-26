class AddProcessingStatusToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :processing_status, :integer, default: 0
  end
end
