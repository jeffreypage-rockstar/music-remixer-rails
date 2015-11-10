class User < ActiveRecord::Base
  include Clearance::User
  has_many :authentications, :dependent => :destroy

	# has many songs catalog
	has_many :songs
	has_many :remixes

  # profile images
  mount_uploader :profile_image, ProfileImageUploader
  # mount_uploader :profile_background_image, ProfileBackgroundUploader

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
# NOTE: this causes double validation errors, Clearance must be doing it to?
#  validates :email, :presence => true, :email => true, :uniqueness => {:case_sensitive => false}

  after_create :send_welcome_email

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
	  create! do |u|
		  # u.name = trim("#{auth_hash["info"]["first_name"]} #{auth_hash["info"]["first_name"]}")
		  u.name = auth_hash["info"]["name"]
		  u.email = auth_hash["extra"]["raw_info"]["email"]
		  u.username = auth_hash["extra"]["raw_info"]["username"]
		  u.authentications << (authentication)
	  end
  end

  def fb_token
	  x = self.authentications.where(:provider => :facebook).first
	  return x.token unless x.nil?
  end

  def password_optional?
	  true
  end

end
