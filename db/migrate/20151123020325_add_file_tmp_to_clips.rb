class AddFileTmpToClips < ActiveRecord::Migration
  def change
    add_column :clips, :file_tmp, :string
  end
end
