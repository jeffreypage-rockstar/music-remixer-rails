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
		activities_query = PublicActivity::Activity
													 .select('min(id) as id, trackable_id, trackable_type, owner_id, owner_type, `key`, parameters, recipient_id, recipient_type, min(created_at) as created_at')
													 .group('trackable_id, trackable_type, owner_id, owner_type, `key`, parameters, recipient_id, recipient_type')
													 .order('min(created_at) DESC')

		# activities_query = PublicActivity::Activity.order('created_at DESC')
		activities_query = case params[:tab]
												 when 'friends'
													 activities_query.where(owner_id: current_user.followees(User).map(&:id))
												 when 'songs'
													 activities_query.where(key: %w(song.create song.share song.like))
												 when 'remixes'
													 activities_query.where(key: %w(remix.create remix.share remix.like))
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
