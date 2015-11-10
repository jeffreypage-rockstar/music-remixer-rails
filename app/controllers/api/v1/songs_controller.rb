class Api::V1::SongsController < Api::V1::ApiController
	before_action :authenticate_with_token!

	def index
		# songs = Song.search(params).page(params[:page]).per(params[:per_page])
		# render json: songs, meta: pagination(songs, params[:per_page])
		@songs = Song.all
	end

	def show
		@song = Song.includes(:clip_types, :parts, :clips).find(params[:id])
	end

end