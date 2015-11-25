class AddDownloadsCountToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :downloads_count, :integer, default: 0
  end
end
