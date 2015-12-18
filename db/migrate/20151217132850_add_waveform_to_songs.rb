class AddWaveformToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :waveform, :string
  end
end
