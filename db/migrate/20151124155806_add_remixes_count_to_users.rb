class AddRemixesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remixes_count, :integer, default: 0
  end
end
