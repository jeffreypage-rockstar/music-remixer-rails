class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :email, null: false
      t.string :name
      t.string :invite_code, null: false
      t.string :message
      t.boolean :is_artist_referral

      t.references :referring, references: :users, index: true
      t.references :referred, references: :users, index: true
      t.datetime :clicked_at
      t.datetime :signed_up_at

      t.timestamps null: false
    end
  end
end
