class AddNewConfigurationFieldToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :mixaudio, :text
    add_column :songs, :mixaudio2, :text
    add_column :songs, :mixaudio3, :text
    remove_column :songs, :mixed_file, :text
  end
end
