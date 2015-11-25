class AddFileProcessingToClips < ActiveRecord::Migration
  def change
    add_column :clips, :file_processing, :boolean, null: false, default: false
  end
end
