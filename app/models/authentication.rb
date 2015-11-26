class Authentication < ActiveRecord::Base
  PROVIDERS = %w(facebook twitter tumblr google_oauth2 soundcloud lastfm)
	belongs_to :user

	def self.create_with_omniauth(auth_hash)
		create! do |auth|
			auth.provider = auth_hash["provider"]
			auth.uid = auth_hash["uid"]
			auth.token = auth_hash["credentials"]["token"]
		end
	end

	def update_token(auth_hash)
		self.token = auth_hash["credentials"]["token"]
		self.save
	end

end