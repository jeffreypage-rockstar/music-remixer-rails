class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.references :song, index:true
      t.string :name, limit: 40
      t.integer :column
      t.float :duration

      t.timestamps null: false
    end
  end
end
