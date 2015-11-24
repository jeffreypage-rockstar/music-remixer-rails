class AddMixaudioProcessingToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :mixaudio_processing, :boolean, null: false, default: false
  end
end
