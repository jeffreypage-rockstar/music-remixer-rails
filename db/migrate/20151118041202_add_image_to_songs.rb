class AddImageToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :image, :string
  end
end
