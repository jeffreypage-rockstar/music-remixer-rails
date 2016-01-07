class CreateMusicBackgrounds < ActiveRecord::Migration
  def change
    create_table :music_backgrounds do |t|
      t.string :name, null: false
    end
  end
end
