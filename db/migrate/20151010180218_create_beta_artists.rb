class CreateBetaArtists < ActiveRecord::Migration
  def change
    create_table :beta_artists do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :artist_name, null: false
      t.string :invite_code, null: false
      t.string :artist_url
      t.boolean :is_active, default: false

      t.timestamps null: false
    end
  end
end
