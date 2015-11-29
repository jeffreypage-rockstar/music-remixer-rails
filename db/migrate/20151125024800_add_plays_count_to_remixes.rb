class AddPlaysCountToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :plays_count, :integer, default: 0
  end
end
