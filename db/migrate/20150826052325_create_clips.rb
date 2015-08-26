class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.integer :song_id
      t.string :name
      t.integer :row
      t.integer :column
      t.float :duration
      t.boolean :state

      t.timestamps null: false
    end
  end
end
