class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.references :song, index:true
      t.references :part, index:true
      t.references :clip_type, index:false

      t.string :uuid, :limit => 24

      t.integer :row
      t.integer :column
      t.boolean :state, default: false
      t.boolean :state2, default: false
      t.boolean :state3, default: false
      t.boolean :allow_ugc, default: false
      t.float   :duration

      t.string :original_filename
      t.string :file
      t.string :file_tmp
      t.integer :storing_status, default: 0

      t.timestamps null: false

      t.index :uuid, :unique => true
    end
  end
end
