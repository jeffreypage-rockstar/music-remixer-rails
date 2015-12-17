class AddStatusToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :status, :integer, default: 0
  end
end
