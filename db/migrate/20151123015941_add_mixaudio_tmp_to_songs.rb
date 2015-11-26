class AddMixaudioTmpToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :mixaudio_tmp, :string
  end
end
