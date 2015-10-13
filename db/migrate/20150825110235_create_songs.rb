class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name, null: false
      t.float :duration
      t.text :zipfile

      t.timestamps null: false
    end
  end
end
