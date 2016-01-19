class Artist::ArtistController < Artist::BaseController
	before_action :set_activities, only: [:connect, :activities]

	def index
		redirect_to artist_profile_path
	end

	def profile
	end

	def edit_profile
		@active_tab = params[:tab] || 'profile'
	end

	def update_profile
		if @artist.update(profile_params)
      $tracker.track current_user.uuid, 'Artist: Profile updated'
			redirect_to artist_profile_path, notice: 'Profile successfully updated'
		else
			@active_tab = 'profile'
			render :edit_profile
		end
	end

	def update_account
		if @artist.update(account_params)
      $tracker.track current_user.uuid, 'Artist: Account updated'
			sign_in @artist
			redirect_to artist_profile_path, notice: 'Account successfully updated'
		else
			@active_tab = 'account'
			render :edit_profile
		end
	end

	# TODO: get rid of dashboard?
	def dashboard
		redirect_to artist_profile_path
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
