class AddNewConfigurationFieldToClips < ActiveRecord::Migration
  def change
    add_column :clips, :state2, :boolean
    add_column :clips, :state3, :boolean
  end
end
