class ArtistController < ApplicationController
  before_action :require_login, :except => [:join]

  def join
		if request.post? && params.include?(:beta_artist)

		else
			@beta_artist = BetaArtist.new
		end
  end

  def profile
  end

  def dashboard
  end

  def music
    @songs = Song.all
  end

  def connect
  end
end
