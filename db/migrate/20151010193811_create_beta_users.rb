class CreateBetaUsers < ActiveRecord::Migration
  def change
    create_table :beta_users do |t|
      t.string :name
      t.string :email
      t.string :message

      t.timestamps null: false
    end
  end
end
