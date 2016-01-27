class BetaArtistsController < ApplicationController
  layout 'artist_signup'

  def join
    if request.post? && params.include?(:user)
      @beta_artist = BetaArtist.new(beta_artist_params)
      if @beta_artist.save
        redirect_to '/beta/thanks'
      else
        render :join
      end
    else
      @beta_artist = BetaArtist.new
      @user = User.new
    end
  end

  def thanks

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def beta_artist_params
    params.require(:user).permit(:name, :email, :username, :password)
  end
end
