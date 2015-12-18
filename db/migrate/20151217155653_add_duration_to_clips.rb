class AddDurationToClips < ActiveRecord::Migration
  def change
    add_column :clips, :duration, :float
  end
end
