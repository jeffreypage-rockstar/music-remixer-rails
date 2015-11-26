class AddStoringStatusToClips < ActiveRecord::Migration
  def change
    add_column :clips, :storing_status, :integer, default: 0
  end
end
