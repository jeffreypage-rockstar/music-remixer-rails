class UpdateSongs < ActiveRecord::Migration
  def change
    add_column :songs, :mixaudio_mix2, :string
    add_column :songs, :mixaudio_mix2_tmp, :string
    add_column :songs, :mixaudio_mix3, :string
    add_column :songs, :mixaudio_mix3_tmp, :string
  end
end
