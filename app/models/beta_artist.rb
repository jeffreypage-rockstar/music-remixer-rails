class BetaArtist < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true, email: true
	validates :artist_name, presence: true
	validates :artist_url, presence: true
end
