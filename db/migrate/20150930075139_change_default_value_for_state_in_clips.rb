class ChangeDefaultValueForStateInClips < ActiveRecord::Migration
  def change
  	change_column :clips, :state, :boolean, default: false
  	change_column :clips, :state2, :boolean, default: false
    change_column :clips, :state3, :boolean, default: false
  end
end
