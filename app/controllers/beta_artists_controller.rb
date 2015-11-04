class BetaArtistsController < ApplicationController
  # layout 'auth'

  def join
    if request.post? && params.include?(:beta_artist)
      @beta_artist = BetaArtist.new(beta_artist_params)
      if @beta_artist.save
        redirect_to '/beta/thanks'
      else
        render :join
      end
    else
      @beta_artist = BetaArtist.new
    end
  end

  def thanks

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def beta_artist_params
    params.require(:beta_artist).permit(:name, :email, :artist_name, :invite_code)
  end
end
