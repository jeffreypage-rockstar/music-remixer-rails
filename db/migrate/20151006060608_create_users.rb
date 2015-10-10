class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :username, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.boolean :is_admin, default: false
      t.boolean :is_artist, default: false
      t.index :email
      t.index :username
      t.index :remember_token
    end
  end
end
