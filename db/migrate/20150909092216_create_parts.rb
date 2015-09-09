class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :song_id
      t.string :name
      t.float :duration
      t.string :column

      t.timestamps null: false
    end
  end
end
