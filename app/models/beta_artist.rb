class BetaArtist < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true, email: true
	validates :artist_name, presence: true
	validates :invite_code, presence: true
end
