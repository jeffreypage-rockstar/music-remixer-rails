class User < ActiveRecord::Base
  include Clearance::User

  # artist administration
  has_many :artists

  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :email, presence: true, email: true, :uniqueness => {:case_sensitive => false}

  after_create :send_welcome_email

  def admin?
    is_admin
  end

  def send_welcome_email

  end
end
