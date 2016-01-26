class CreateBetaArtists < ActiveRecord::Migration
  def change
    create_table :beta_artists do |t|
      t.references :user, index:true
      t.string :name, null: false
      t.string :email, null: false
      t.string :artist_name, null: false
      t.string :artist_url, null: false
      t.text   :message
      t.string :invite_code

      t.timestamps null: false

      t.index :email, :unique => true
    end
  end
end
