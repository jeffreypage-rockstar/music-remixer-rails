class Artist::ArtistController < Artist::BaseController
	before_action :set_activities, only: [:connect, :activities]

	def index
		redirect_to artist_music_path
	end

	def dashboard
		redirect_to artist_music_path
	end

	def music
	end

	def connect
		@active_tab = params[:tab] || 'all'
	end

	def activities
		respond_to do |format|
			format.js
		end
	end

	protected

	def set_activities
		activities_query = PublicActivity::Activity.order('created_at DESC')
		activities_query = case params[:tab]
												 when 'friends'
													 activities_query.where(owner_id: current_user.followees(User).map(&:id))
												 when 'songs'
													 activities_query.where(key: %w(song.create song.share song.like song.unlike))
												 else
													 activities_query
											 end
		@activities = activities_query.page(params[:page])
  end

	def profile_params
		params.require(:user).permit(:name, :location, :bio, :genre_list, :facebook, :instagram, :twitter, :soundcloud, :profile_image, :profile_image_cache, :profile_background_image, :profile_background_image_cache)
	end

	def account_params
		params.require(:user).permit(:email, :username, :password)
	end

end
