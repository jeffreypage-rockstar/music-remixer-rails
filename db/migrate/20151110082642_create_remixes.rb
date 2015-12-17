class CreateRemixes < ActiveRecord::Migration
  def change
    create_table :remixes do |t|
	    t.belongs_to  :user
	    t.belongs_to  :song
	    # do we care about tracking remixes of remixes?
	    # t.integer     :base_remix_id
	    t.string      :name
	    t.text        :config
	    t.integer     :status

      t.integer :downloads_count, default: 0
      t.integer :plays_count, default: 0

      t.timestamps
    end
  end
end
