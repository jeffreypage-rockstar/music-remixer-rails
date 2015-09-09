class ChangeDataTypeInClips < ActiveRecord::Migration
  def change
  	change_column :clips, :row, :string
    change_column :clips, :column, :string
  end
end
