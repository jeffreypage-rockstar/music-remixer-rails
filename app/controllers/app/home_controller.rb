class App::HomeController < App::BaseController
	def index
		@songs = Song.all
	end
end
