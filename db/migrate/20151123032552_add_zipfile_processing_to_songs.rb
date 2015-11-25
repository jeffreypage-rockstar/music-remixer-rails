class AddZipfileProcessingToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :zipfile_processing, :boolean, null: false, default: false
  end
end
