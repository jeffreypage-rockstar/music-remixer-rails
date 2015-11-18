class AddStatusToSong < ActiveRecord::Migration
  def change
	  add_column :songs, :status, :integer, default: 0
  end
end
