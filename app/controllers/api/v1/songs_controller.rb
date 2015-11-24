class Api::V1::SongsController < Api::V1::ApiController
	before_action :authenticate_with_token!

	def index
		# http://apionrails.icalialabs.com/book/chapter_ten
		# songs = Song.search(params).page(params[:page]).per(params[:per_page])
		# render json: songs, meta: pagination(songs, params[:per_page])

		# only expose "released" songs
		@songs = Song.where('status = ?', Song.statuses[:released])
	end

	def show
		@song = Song.includes(:clip_types, :parts, :clips).where({id: params[:id], status: Song.statuses[:released]}).first
	end

end