class CreateClipTypes < ActiveRecord::Migration
  def change
    create_table :clip_types do |t|
      t.integer :song_id
      t.string :name
      t.integer :row

      t.timestamps null: false
    end
  end
end
