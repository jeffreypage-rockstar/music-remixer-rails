class User < ActiveRecord::Base
	# authentication (clearance and omniauth/fb)
	include Clearance::User
	include PublicActivity::Common
	has_many :authentications, :dependent => :destroy

	# has many songs and remixes
	has_many :songs, -> { order 'songs.created_at desc' }
	has_many :remixes
  has_one :beta_user
  accepts_nested_attributes_for :beta_user

	attr_accessor :invite_code
	enum status: { beta_waitlisted: 0, active: 1, blacklisted: 2, deleted: 3 }

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

	default_value_for :uuid do
		SecureRandom.uuid
	end
	default_value_for :status, User.statuses[:beta_waitlisted]

	validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
	validates_confirmation_of :password
	# NOTE: this causes double validation errors, Clearance must be doing it to?
	#	validates :email, :presence => true, :email => true, :uniqueness => {:case_sensitive => false}

	after_create :send_welcome_email
	before_create :email_confirm_token

	def admin?
		is_admin
	end

	def title
		name
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
		user = self.find_by_email(email)
		if user.nil?
			# new user account added via fb connect
			create! do |u|
				u.name = auth_hash["info"]["name"]
				u.email = auth_hash["extra"]["raw_info"]["email"]
				u.username = self.create_unique_username(u.email)
				u.encrypted_password = SecureRandom.hex(20)
				u.confirmed_at = Time.now
				u.authentications << (authentication)
				user = u
			end
		else
			# user already has account, just adding FB
			user.confirmed_at = Time.now if user.confirmed_at.nil?
			user.authentications << (authentication)
		end
		user
	end

	def fb_token
		x = self.authentications.where(:provider => :facebook).first
		return x.token unless x.nil?
	end

	def password_optional?
		true
	end

	def identity(provider)
		self.authentications.find_by(provider: provider)
	end

	def self.create_unique_username(email)
		loop do
			username = "#{email[/^[^@]*/]}_#{SecureRandom.hex(3)}"
			puts "Trying username: #{username}"
			return username if User.find_by_username(username).nil?
		end
	end

	def self.find_for_facebook_oauth(profile)
		authentication = Authentication.find_for_oauth('facebook', profile['id'])
		user = authentication.user

		if user.nil?
			user = User.find_by(email: profile[:email]) || User.create(
					name: "#{profile['first_name']} #{profile['last_name']}",
					email: profile['email'],
					username: self.create_unique_username(profile['email']),
					encrypted_password: SecureRandom.hex(20),
					confirmed_at: Time.now
			)
		end

		if authentication.user != user
			authentication.user = user
			authentication.save
		end
		user
	end

	def email_activate
		self.email_confirmed = true
		self.confirm_token = nil
		save!(:validate => false)
	end
	private
	def email_confirm_token
		if self.confirm_token.blank?
			self.confirm_token = SecureRandom.urlsafe_base64.to_s
		end
	end


end
