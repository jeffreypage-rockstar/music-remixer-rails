class App::HomeController < App::BaseController
	def index
    @songs = Song.all
  end

  def welcome_modal
    @user = current_user
    render layout: 'modal'
  end

  def install
  end
end
