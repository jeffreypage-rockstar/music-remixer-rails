class ChangeDurationForSongs < ActiveRecord::Migration
  def change
    change_column :songs, :duration, :float
  end
end
