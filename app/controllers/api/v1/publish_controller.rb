class Api::V1::PublishController < Api::V1::ApiController
	before_action :authenticate_with_token!

	# POST /publish/mix
	def mix
	end

	# POST /publish/audio
	def audio
	end
end