class AddMixedSongFilePathToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :mixed_file, :text
  end
end
