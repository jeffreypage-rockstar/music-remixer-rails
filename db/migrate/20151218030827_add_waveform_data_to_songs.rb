class AddWaveformDataToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :waveform_data, :string
  end
end
