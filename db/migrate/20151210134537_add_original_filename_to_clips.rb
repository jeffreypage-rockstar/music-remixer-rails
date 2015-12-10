class AddOriginalFilenameToClips < ActiveRecord::Migration
  def change
    add_column :clips, :original_filename, :string
  end
end
