class AddUuidToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :uuid, :string
  end
end
