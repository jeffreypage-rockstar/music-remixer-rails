class AddAdditionalFieldsToBetaUsers < ActiveRecord::Migration
  def change
    add_column :beta_users, :age, :integer
    add_column :beta_users, :phone_type, :integer
    add_column :beta_users, :music_background, :integer
  end
end
