class AddPlaysCountToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :plays_count, :integer, default: 0
  end
end
