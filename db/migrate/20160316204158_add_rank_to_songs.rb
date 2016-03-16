class AddRankToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :rank, :integer, :default => 999999
  end
end
