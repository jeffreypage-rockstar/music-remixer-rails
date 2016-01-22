class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.references :user, index:true
      t.string  :name, null: false
      t.integer :status, default: 0
      t.float   :duration
      t.integer :bpm

      t.string :zipfile
      t.string :zipfile_tmp

      t.string :mixaudio
      t.string :mixaudio_tmp

      t.string :waveform
      t.string :waveform_data

      t.string :image

      t.string :uuid, :limit => 24

      t.integer :downloads_count, default: 0
      t.integer :plays_count, default: 0
      t.integer :remixes_count, default: 0

      t.timestamps null: false

      t.index :uuid, :unique => true
    end
  end
end
