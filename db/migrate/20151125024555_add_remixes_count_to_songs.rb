class AddRemixesCountToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :remixes_count, :integer, default: 0
  end
end
