class AddSocialLinksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_link, :string
    add_column :users, :twitter_link, :string
    add_column :users, :soundcloud_link, :string
  end
end
