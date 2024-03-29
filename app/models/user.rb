class User < ActiveRecord::Base
  # authentication (clearance and omniauth/fb)
  include Clearance::User
  include PublicActivity::Common
  has_many :authentications, :dependent => :destroy

  # has many songs and remixes
  has_many :songs, -> { order 'songs.created_at desc' }
  has_many :released_songs, -> { where(status: Song.statuses[:released]).order('songs.created_at desc')}, class_name: 'Song'
  has_many :artist_visible_songs, -> { where(status: [Song.statuses[:processing], Song.statuses[:working], Song.statuses[:released], Song.statuses[:processing_for_release]]).order('songs.created_at desc')}, class_name: 'Song'

  has_many :remixes
  has_many :released_remixes, -> { where(status: Remix.statuses[:published]).order('remixes.created_at desc')}, class_name: 'Remix'

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
  # acts_as_mentionable

  # allow comments on users
  acts_as_commentable

	# profile images
	mount_uploader :profile_image, ProfileImageUploader
	mount_uploader :profile_background_image, ProfileBackgroundImageUploader

	default_value_for :uuid do #important, needs to be in a block
		SecureRandom.hex(6)
	end
	default_value_for :status, User.statuses[:beta_waitlisted]

  validates :name, :presence => true
  validates :email, :presence => true
	validates :username, :presence => true, :uniqueness => {:case_sensitive => false}, :format => { :with => /\A[a-zA-Z0-9_\-]+\z/, :message => "can contain only a-z, A-Z, 0-9, _ and -" }
	# validates :facebook, :format => { :with => /\A[a-zA-Z0-9_\-]+\z/, :message => "can contain only a-z, A-Z, 0-9, _ and -" }, :unless => Proc.new { |a| a.facebook.blank? }
	# validates :twitter, :format => { :with => /\A[a-zA-Z0-9_\-]+\z/, :message => "can contain only a-z, A-Z, 0-9, _ and -" }, :unless => Proc.new { |a| a.twitter.blank? }
	# validates :soundcloud, :format => { :with => /\A[a-zA-Z0-9_\-]+\z/, :message => "can contain only a-z, A-Z, 0-9, _ and -" }, :unless => Proc.new { |a| a.soundcloud.blank? }
	# validates :instagram, :format => { :with => /\A[a-zA-Z0-9_\-]+\z/, :message => "can contain only a-z, A-Z, 0-9, _ and -" }, :unless => Proc.new { |a| a.instagram.blank? }
	validates :password, :presence => true, :on => :create
	validates_confirmation_of :password, :message => 'Passwords do not match'
	validates :terms_of_service, acceptance: true
	# NOTE: this causes double validation errors, Clearance must be doing it to?
	#	validates :email, :presence => true, :email => true, :uniqueness => {:case_sensitive => false}

	after_create :send_welcome_email
	before_create :email_confirmation_token

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

	def self.create_with_auth_hash(auth_hash)
		puts "in create_with_auth_hash: #{auth_hash.inspect}"
    # new user account added via fb connect
    user = nil
    create! do |u|
      u.name = auth_hash["info"]["name"]
      u.email = auth_hash["extra"]["raw_info"]["email"]
      u.username = self.create_unique_username(u.email)
      u.password = SecureRandom.hex(20)
      u.confirmed_at = Time.now
      user = u
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
			username = "#{email[/^[^@]*/]}_#{SecureRandom.hex(2)}"
      username = username.gsub('.', '-')
      logger.debug("Trying username: #{username}")
			return username if User.find_by_username(username).nil?
		end
	end

	def self.find_for_facebook_oauth(profile)
		authentication = Authentication.find_for_oauth('facebook', profile['id'])
		user = authentication.user

		if user.nil?
			user = User.find_by(email: profile['email']) || User.create(
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
		self.confirmed_at = Time.now
		self.confirmation_token = nil
		save!(:validate => false)
	end

	private
	def email_confirmation_token
		if self.confirmation_token.blank?
			self.confirmation_token = SecureRandom.urlsafe_base64.to_s
		end
		true
	end

end
