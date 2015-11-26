class AddZipfileTmpToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :zipfile_tmp, :string
  end
end
