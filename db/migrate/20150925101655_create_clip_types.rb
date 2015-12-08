class CreateClipTypes < ActiveRecord::Migration
  def change
    create_table :clip_types do |t|
      t.references :song, index:true
      t.string :name, limit: 40
      t.integer :row

      t.timestamps null: false
    end
  end
end
