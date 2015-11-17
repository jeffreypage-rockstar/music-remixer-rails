class Api::V1::UsersController < Api::V1::ApiController
	before_action :authenticate_with_token!, only: [:show]

	# GET /users/<id>
	def show
		@user = User.find(params[:id])
	end

	# POST /users/signup
	def signup
		user = User.new(user_params)
		if user.save
			@token = user.remember_token
			render :token, status: 200
		else
			render json: { errors: user.errors }, status: 422
		end
	end

	# POST /users/login
	def login
		unless params[:username].nil? || params[:password].nil?
			username = params[:username]
			password = params[:password]
			user = User.find_by(username: username) || User.find_by(email: username)

			if !user.nil? && user.authenticated?(password)
				@token = user.remember_token
				return render :token, status: 200
			end
		end

		render json: { errors: "Invalid username or password" }, status: 422
	end

	# POST /users/logout
	def logout
		if signed_in?
			current_user.remember_token = SecureRandom.hex(32).encode('UTF-8') # Clearance::Token.new (only 20 chars)
			current_user.save!
		end
		render json: {}, status: 200
	end

	private

	def user_params
		params.permit(:email, :password, :username)
	end
end