class CreateRemixes < ActiveRecord::Migration
  def change
    create_table :remixes do |t|
	    t.belongs_to  :user
	    t.belongs_to  :song
	    # do we care about tracking remixes of remixes?
	    # t.integer     :base_remix_id

      t.string      :uuid, :limit => 24
	    t.string      :name
      t.integer     :status, default: 0

	    t.text        :config
      t.text        :automation

      t.string      :audio
      t.string      :audio_tmp

      t.integer     :downloads_count, default: 0
      t.integer     :plays_count, default: 0

      t.timestamps

      t.index :uuid, :unique => true
    end
  end
end
