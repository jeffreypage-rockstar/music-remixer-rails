#require 'tmail'

class BetaUser < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true, email: true

	before_save :ensure_invite_code

	def ensure_invite_code
		if self.invite_code.nil?
			self.invite_code = Digest::SHA1.hexdigest([Time.now, rand].join)
		end
	end

end
