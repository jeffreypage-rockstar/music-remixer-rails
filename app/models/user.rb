class User < ActiveRecord::Base
  include Clearance::User

	# has many songs catalog
	has_many :songs
	has_many :remixes

  # profile images
  mount_uploader :profile_image, ProfileImageUploader
  # mount_uploader :profile_background_image, ProfileBackgroundUploader

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :email, presence: true, email: true, :uniqueness => {:case_sensitive => false}

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

end
