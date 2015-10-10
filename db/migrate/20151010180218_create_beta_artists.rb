class CreateBetaArtists < ActiveRecord::Migration
  def change
    create_table :beta_artists do |t|
      t.string :name
      t.string :email
      t.string :artist_name
      t.string :invite_code
      t.string :artist_url
      t.boolean :is_active

      t.timestamps null: false
    end
  end
end
