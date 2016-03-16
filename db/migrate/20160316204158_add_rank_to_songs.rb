class AddRankToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :rank, :integer
  end
end
