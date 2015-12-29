class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.references :user, index:true
      t.string :name, null: false
      t.integer :status, default: 0
      t.integer :duration
      t.integer :bpm
      t.string :zipfile
      t.string :mixaudio
      t.string :image
      t.string :uuid, :limit => 24

      t.integer :downloads_count, default: 0
      t.integer :plays_count, default: 0
      t.integer :remixes_count, default: 0

      t.timestamps null: false
    end
  end
end
