class App::HomeController < App::BaseController
	def index
    if Rails.env.development?
      @songs = Song.all
    else
      @songs = Song.released
    end
  end

  def welcome_modal
    @user = current_user
    render layout: 'modal'
  end

  def install
  end
end
