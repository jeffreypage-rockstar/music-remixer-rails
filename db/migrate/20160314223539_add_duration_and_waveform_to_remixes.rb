class AddDurationAndWaveformToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :duration, :float
    add_column :remixes, :waveform, :string
  end
end
