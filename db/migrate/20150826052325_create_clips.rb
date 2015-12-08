class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.references :song, index:true
      t.references :part, index:true
      t.references :clip_type, index:false
      t.string  :file
      t.integer :row
      t.integer :column
      t.string :uuid

      t.boolean :state, default: false
      t.boolean :state2, default: false
      t.boolean :state3, default: false
      t.boolean :allow_ugc, default: false

      t.timestamps null: false
    end
  end
end
