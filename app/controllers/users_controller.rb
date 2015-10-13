class UsersController < Clearance::UsersController
	# layout 'auth', :only => [:create, :new]

	def new
		if !params[:invite_code].nil?
			session[:invite_code] = params[:invite_code]
			redirect_to '/sign_up'
		# elsif session[:invite_code].nil?
		# 	redirect_to '/', :alert => 'Sorry, you must have an invite code to sign up!'
		else
			@user = User.new
		end
	end

	def create
		render template: 'users/new' if session[:invite_code].nil?

		beta = BetaUser.find_by_invite_code(session[:invite_code])
		if beta.user_id.nil?
			@user = user_from_params

			if @user.save
				session.delete(:invite_code)
				beta.user_id = @user.id
				beta.save
				sign_in @user
				redirect_to '/', :info => 'Thanks for signing up!'
			else
				render template: 'users/new'
			end
		else
			redirect_to '/', :alert => 'Sorry, this invite code has already been used.'
		end
	end

	private

	def user_from_params
		user_params = params[:user] || Hash.new
		username = user_params.delete(:username)
		email = user_params.delete(:email)
		password = user_params.delete(:password)

		Clearance.configuration.user_model.new(user_params).tap do |user|
			user.username = username
			user.email = email
			user.password = password
		end
	end
end