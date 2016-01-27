class CreateBetaUsers < ActiveRecord::Migration
  def change
    create_table :beta_users do |t|
      t.references :user, index:true

      t.string :name, null: false
      t.string :email, null: false
      t.string :message
      t.string :invite_code, null: false
      t.integer :age
      t.integer :phone_type

      # TODO: add geoip location

      t.timestamps null: false
    end
  end
end
