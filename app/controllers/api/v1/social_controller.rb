class Api::V1::SocialController < Api::V1::ApiController
	before_action :authenticate_with_token!

	def stream
		@activities = PublicActivity::Activity.all
	end

	def share
		# @song = Song.includes(:clip_types, :parts, :clips).find(params[:id])
	end

end