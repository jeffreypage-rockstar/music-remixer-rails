class AddProfileDataToUser < ActiveRecord::Migration
  def change
	  add_column :users, :location, :string, :limit => 128
	  add_column :users, :bio, :text
  end
end
