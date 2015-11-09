class Api::V1::SongsController < Api::V1::ApiController
	before_action :authenticate_with_token!, only: [:create, :update, :destroy]
	respond_to :json

	def index
		# songs = Song.search(params).page(params[:page]).per(params[:per_page])
		# render json: songs, meta: pagination(songs, params[:per_page])
		@songs = Song.all
	end

	def show
		@song = Song.find(params[:id])
	end

	# def create
	# 	song = current_user.songs.build(song_params)
	# 	if song.save
	# 		render json: song, status: 201, location: [:api, song]
	# 	else
	# 		render json: { errors: song.errors }, status: 422
	# 	end
	# end
	#
	# def update
	# 	song = current_user.songs.find(params[:id])
	# 	if song.update(song_params)
	# 		render json: song, status: 200, location: [:api, song]
	# 	else
	# 		render json: { errors: song.errors }, status: 422
	# 	end
	# end
	#
	# def destroy
	# 	song = current_user.songs.find(params[:id])
	# 	song.destroy
	# 	head 204
	# end
	#
	# private
	#
	# def song_params
	# 	params.require(:song).permit(:title, :price, :published)
	# end

end