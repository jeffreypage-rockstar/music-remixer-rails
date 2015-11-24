class Artist::ArtistController < ApplicationController
	before_action :require_login
	before_action :validate_artist

	def index
		redirect_to artist_profile_path
	end

	def profile
	end

	def edit_profile
		@active_tab = 'profile'
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
		@artist = current_user.decorate

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
		redirect_to artist_profile_path, notice: 'Successfully followed'
	end

	def unfollow
		authorize @artist
		current_user.unfollow! @artist
		redirect_to artist_profile_path, notice: 'Successfully unfollowed'
	end

	# TODO: get rid of dashboard?
	def dashboard
		redirect_to artist_profile_path
	end

	def music
	end

	def connect
		# TOOD: add pagination
		@activities = PublicActivity::Activity.order('created_at DESC').all
	end

	protected

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
