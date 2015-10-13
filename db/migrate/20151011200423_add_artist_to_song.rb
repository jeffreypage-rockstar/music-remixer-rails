class AddArtistToSong < ActiveRecord::Migration
  def change
    add_column :songs, :artist_id, :integer, references: :artists
  end
end
