class AddAutomationToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :automation, :text
  end
end
