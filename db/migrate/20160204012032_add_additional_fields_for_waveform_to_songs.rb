class AddAdditionalFieldsForWaveformToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :waveform_mix2, :string
    add_column :songs, :waveform_data_mix2, :string
    add_column :songs, :waveform_mix3, :string
    add_column :songs, :waveform_data_mix3, :string
  end
end
