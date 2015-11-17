class Artist::ArtistController < ApplicationController
	before_action :require_login
	before_action :validate_artist

	def index
		redirect_to artist_profile_path
	end

	def profile
		@artist = current_user
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

end
