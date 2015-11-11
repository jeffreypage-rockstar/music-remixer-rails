class Artist::ArtistController < ApplicationController
	before_action :require_login
	before_action :validate_artist

	def profile
		puts "Artist::profile"
		puts current_user.inspect
	end

	def dashboard
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
