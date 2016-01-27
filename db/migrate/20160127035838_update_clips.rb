class UpdateClips < ActiveRecord::Migration
  def change
    add_column :clips, :file_aac, :string
    add_column :clips, :file_aac_tmp, :string
  end
end
