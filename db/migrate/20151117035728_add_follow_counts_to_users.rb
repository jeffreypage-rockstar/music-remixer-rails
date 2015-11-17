class AddFollowCountsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followees_count, :integer, default: 0
    add_column :users, :followers_count, :integer, default: 0
  end
end
