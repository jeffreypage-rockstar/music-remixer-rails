class User < ActiveRecord::Base
	# authentication (clearance and omniauth/fb)
	include Clearance::User
	has_many :authentications, :dependent => :destroy

	# has many songs and remixes
	has_many :songs
	has_many :remixes

	attr_accessor :invite_code

	# artist genres
	acts_as_taggable_on :genres

	# follow, like, mention (from socialization gem)
	acts_as_follower
	acts_as_followable
	acts_as_liker
	acts_as_likeable
	acts_as_mentionable

	# profile images
	mount_uploader :profile_image, ProfileImageUploader
	mount_uploader :profile_background_image, ProfileBackgroundImageUploader

	validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
	# NOTE: this causes double validation errors, Clearance must be doing it to?
	#	validates :email, :presence => true, :email => true, :uniqueness => {:case_sensitive => false}
	validates :invite_code, presence: true
	validate :invite_code_should_be_available

	after_create :send_welcome_email

	def invite_code_should_be_available
		unless BetaUser.exists?(invite_code: self.invite_code, user_id: nil)
			self.errors.add :invite_code, 'Sorry, this invite code is no longer valid.'
		end
	end

	def admin?
		is_admin
	end

	def send_welcome_email
		# TODO send_welcome_email
	end

	def profile_image_changed?
		# TODO: figure out why save! fails without this
		# will probably prevent user from updating their profile image
		false
	end

	def self.create_with_auth_and_hash(authentication, auth_hash)
		puts "in create_with_auth_and_hash: #{auth_hash.inspect}"
		email = auth_hash["extra"]["raw_info"]["email"]
		u = self.find_by_email(email)
		if u.nil?
			# new user account added via fb connect
			create! do |u|
				# u.name = trim("#{auth_hash["info"]["first_name"]} #{auth_hash["info"]["first_name"]}")
				u.name = auth_hash["info"]["name"]
				u.email = auth_hash["extra"]["raw_info"]["email"]
				u.username = self.create_unique_username(u.email)
				u.encrypted_password = SecureRandom.hex(20)
				u.confirmed_at = Time.now
				u.authentications << (authentication)
			end
		else
			# user already has account, just adding FB
			u.confirmed_at = Time.now if u.confirmed_at.nil?
			u.authentications << (authentication)
		end
		puts "create_with_auth_and_hash: returning #{u.inspect}"
		return u
	end

	def fb_token
		x = self.authentications.where(:provider => :facebook).first
		return x.token unless x.nil?
	end

	def password_optional?
		true
	end

	def self.create_unique_username(email)
		loop do
			username = "#{email[/^[^@]*/]}_#{SecureRandom.hex(3)}"
			puts "Trying username: #{username}"
			return username if User.find_by_username(username).nil?
		end
	end

end
