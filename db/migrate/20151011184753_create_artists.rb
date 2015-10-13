class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.references :user, index: true
      t.string :name
      t.string :url

      t.timestamps null: false
    end
  end
end
