class Api::V1::AppController < Api::V1::ApiController

	def install
		# TODO: log that the app was installed
	end

	def startup
		# return their user token if they are auth'd
		@token = user_signed_in? ? current_user.remember_token : ''
	end
end