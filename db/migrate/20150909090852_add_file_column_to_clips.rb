class AddFileColumnToClips < ActiveRecord::Migration
  def change
  	add_column :clips, :part_id, :integer
    add_column :clips, :file, :text
  end
end
