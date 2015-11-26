class AddUuidToClips < ActiveRecord::Migration
  def change
    add_column :clips, :uuid, :string
  end
end
