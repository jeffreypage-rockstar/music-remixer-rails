class CreateAuthentications < ActiveRecord::Migration
	def change
		create_table :authentications do |t|
			t.belongs_to  :user

			t.string    :provider, null: false
			t.string    :uid, null: false
			t.string    :token
			t.string    :refresh_token
			# t.string    :secret
			# t.datetime  :expires_at
			# t.text      :oauth_data_json
			# t.string    :username
			# t.string    :image_url

			t.timestamps
		end
		add_index :authentications, :provider
	end
end
