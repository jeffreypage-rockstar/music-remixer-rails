class Artist::ArtistController < Artist::BaseController
	before_action :require_login
	before_action :validate_artist
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
			redirect_to artist_profile_path, notice: 'Profile successfully updated'
		else
			@active_tab = 'profile'
			render :edit_profile
		end
	end

	def update_account
		if @artist.update(account_params)
			sign_in @artist
			redirect_to artist_profile_path, notice: 'Account successfully updated'
		else
			@active_tab = 'account'
			render :edit_profile
		end
	end

	def follow
		authorize @artist
		current_user.follow! @artist
		@artist.create_activity :follow, owner: current_user
		redirect_to artist_profile_path, notice: 'Successfully followed'
	end

	def unfollow
		authorize @artist
		current_user.unfollow! @artist
		@artist.create_activity :unfollow, owner: current_user
    redirect_to artist_profile_path, notice: 'Successfully unfollowed'
	end

	# TODO: get rid of dashboard?
	def dashboard
		redirect_to artist_profile_path
	end

	def disconnect_identity
		@artist = current_user
		provider = params[:provider]
		if Authentication::PROVIDERS.include? provider
			@artist.identity(provider).destroy
			redirect_to artist_edit_profile_path(tab: 'connections'), notice: "Successfully disconnected from #{provider}"
		end
	end

	def music
	end

	def connect
		@active_tab = 'all'
	end

	def activities
		respond_to do |format|
			format.js
		end
	end

	protected

	def set_activities
		@activities = PublicActivity::Activity.order('created_at DESC').page(params[:page]).per(2)
  end

	def validate_artist
		redirect_to root_url unless current_user.is_artist_admin?
	end

	def profile_params
		params.require(:user).permit(:name, :location, :bio, :genre_list, :facebook, :instagram, :twitter, :soundcloud, :profile_image, :profile_image_cache, :profile_background_image, :profile_background_image_cache)
	end

	def account_params
		params.require(:user).permit(:email, :username, :password)
	end

end
