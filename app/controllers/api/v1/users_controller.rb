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

	# POST /users/connect
	def connect
		# TODO: handle for creating new user
		# TODO: handle for authing existng user, previously auth'd
		# TODO: handle for authing existing user, not previously auth'd
		unless params[:provider].nil? || params[:token].nil? || params[:email].nil? || params[:uid].nil?
			# token = params[:token]
			# email = params[:email]
			# provider = params[:provider]
			# uid = params[:uid]
			# name = params[:name]

			auth_hash = {}
			auth_hash["provider"] = params[:provider]
			auth_hash["uid"] = params[:uid]
			auth_hash["credentials"] = {"token" => params[:token]}
			auth_hash["extra"]= {"raw_info" => {"email" => params[:email]}}
			auth_hash["info"] = {"name" => params[:name]}

			authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
			if authentication.user
				user = authentication.user
				authentication.update_token(auth_hash)
			else
				user = User.create_with_auth_and_hash(authentication, auth_hash)
			end

			if !user.nil?
				@token = user.remember_token
				return render :token, status: 200
			else
				render json: { errors: user.errors }, status: 422
			end
		end

		render json: { errors: "Invalid or missing parameters" }, status: 422
	end

	private

	def user_params
		params.permit(:email, :password, :username)
	end
end