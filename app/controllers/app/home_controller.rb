class App::HomeController < App::BaseController
	def index
    if Rails.env.development?
      @songs = Song.all
    else
      @songs = Song.released
    end

    # collect the unique artists from the live songs
    artists = {}
    @songs.each do |song|
      artists[song.user_id] = song.user
    end
    @artists = artists.values
  end

  def welcome_modal
    @user = current_user
    render layout: 'modal'
  end

  def install
  end
end
