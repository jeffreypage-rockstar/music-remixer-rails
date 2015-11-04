class ArtistController < ApplicationController
  before_action :require_login, :except => [:join]
	before_action :validate_artist, :except => [:join]

  def profile
  end

  def dashboard
  end

  def music
  end

  def connect
  end

	protected
	def validate_artist
		redirect_to '/' unless current_user.is_artist_admin?
	end

end
