class AddDownloadsCountToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :downloads_count, :integer, default: 0
  end
end
