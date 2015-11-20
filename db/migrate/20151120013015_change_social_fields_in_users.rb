class ChangeSocialFieldsInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :facebook_link, :facebook
    rename_column :users, :twitter_link, :twitter
    rename_column :users, :soundcloud_link, :soundcloud
    add_column :users, :instagram, :string
  end
end
