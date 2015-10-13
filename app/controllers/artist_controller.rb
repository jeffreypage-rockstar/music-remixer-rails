class ArtistController < ApplicationController
  before_action :require_login, :except => [:join]
	before_action :validate_artist, :except => [:join]

  def join
		@beta_artist = BetaArtist.new
  end

  def profile
  end

  def dashboard
  end

  def music
		@artists = current_user.artists
  end

  def connect
  end

	protected
	def validate_artist
		redirect_to '/artist/join' unless current_user.is_artist_admin?
	end

end
