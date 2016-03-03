class BetaArtist < ActiveRecord::Base
	validates :name, presence: true
	validates :email, presence: true, email: true
	validates :artist_name, presence: true
	validates :artist_url, presence: true

  default_value_for :invite_code do
    SecureRandom.hex(6)
  end

  # send an invite email to this beta artist
  def invite_to_join
    # $tracker.track @user.uuid, 'Artist Join: success', {'name' => @user.name, 'email' => @user.email}
    ArtistNotifier.artist_invite_to_join_email(self).deliver_now
  end

end
