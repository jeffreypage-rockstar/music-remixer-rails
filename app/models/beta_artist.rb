class BetaArtist < ActiveRecord::Base
  validates :name, presence: true, format: { :with => /[a-zA-Z0-9_-]+/, :message => "can contain only a-z, A-Z, 0-9, _ and -" }
	validates :email, presence: true, email: true
	validates :artist_name, presence: true
	validates :artist_url, presence: true

  default_value_for :invite_code do
    SecureRandom.hex(10)
  end

  # send an invite email to this beta artist
  def invite_to_join
    # $tracker.track @user.uuid, 'Artist Join: success', {'name' => @user.name, 'email' => @user.email}
    UserNotifier.artist_invite_to_join_email(self).deliver_now
  end

end
