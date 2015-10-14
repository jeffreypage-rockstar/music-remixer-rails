class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :name
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.boolean :is_admin, default: false
      t.boolean :is_artist_admin, default: false

      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps null: false

      t.index :email
      t.index :username
      t.index :remember_token
    end
  end
end
