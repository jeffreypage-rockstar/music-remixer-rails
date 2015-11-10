class Api::V1::SocialController < Api::V1::ApiController
	before_action :authenticate_with_token!

	def stream
		# songs = Song.search(params).page(params[:page]).per(params[:per_page])
		# render json: songs, meta: pagination(songs, params[:per_page])
		@songs = Song.all
	end

	def share
		# @song = Song.includes(:clip_types, :parts, :clips).find(params[:id])
	end

end