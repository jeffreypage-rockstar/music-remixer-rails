class Api::V1::SessionsController < Api::V1::ApiController

	def create
		user_email = params[:session][:email]
		user_password = params[:session][:password]
		user = user_email.present? && User.find_by(email: user_email)

		if user.authenticated?(user_password)
			@user = user
		else
			render json: { errors: "Invalid email or password" }, status: 422
		end
	end

	def destroy
		user = User.find_by(remember_token: params[:id])
		if user
			user.remember_token = Clearance::Token.new
			user.save!
		end
		head 204
	end
end