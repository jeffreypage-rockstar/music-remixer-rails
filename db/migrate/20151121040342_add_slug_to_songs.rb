class AddSlugToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :slug, :string
    add_index :songs, :slug, unique: true
  end
end
