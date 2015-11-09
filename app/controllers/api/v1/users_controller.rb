class Api::V1::UsersController < Api::V1::ApiController
	before_action :authenticate_with_token!, only: [:update, :destroy]

	def show
		@user = User.find(params[:id])
	end

	def create
		user = User.new(user_params)
		if user.save
			@user = user
			render status: 201
			# render json: user, status: 201, location: [:api, user]
		else
			render json: { errors: user.errors }, status: 422
		end
	end

	# TODO: need to verify these are all correct, seems weird that it us using current_user
	# def update
	# 	user = current_user
	# 	if user.update(user_params)
	# 		render status: 200
	# 		# render json: user, status: 200, location: [:api, user]
	# 	else
	# 		render json: { errors: user.errors }, status: 422
	# 	end
	# end
	#
	# def destroy
	# 	current_user.destroy
	# 	head 204
	# end

	private

	def user_params
		params.require(:user).permit(:email, :password, :username)
	end
end