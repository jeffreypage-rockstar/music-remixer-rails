class AddAudioToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :audio, :string
  end
end
