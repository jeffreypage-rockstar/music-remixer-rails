class AddSongsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :songs_count, :integer, default: 0
  end
end
