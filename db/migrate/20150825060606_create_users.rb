class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, limit:50, null: false
      t.string :name, limit:80

      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.boolean :is_admin, default: false
      t.boolean :is_artist_admin, default: false

      t.string :uuid, :limit => 24
			t.string :profile_image
			t.string :profile_background_image
      t.string :location, :limit => 80
      t.text :bio

      t.string :facebook
      t.string :twitter
      t.string :soundcloud
      t.string :instagram

      t.integer :followees_count, default: 0
      t.integer :followers_count, default: 0
      t.integer :songs_count, default: 0
      t.integer :remixes_count, default: 0

      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps null: false

      t.index :email
      t.index :username
      t.index :remember_token
    end
  end
end
