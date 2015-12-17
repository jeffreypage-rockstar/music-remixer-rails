class AddAudioTmpToRemixes < ActiveRecord::Migration
  def change
    add_column :remixes, :audio_tmp, :string
  end
end
