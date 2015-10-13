class CreateBetaUsers < ActiveRecord::Migration
  def change
    create_table :beta_users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :message
      t.string :invite_code, null: false
      t.references :user, index:true

      # TODO: add geoip location

      t.timestamps null: false
    end
  end
end
