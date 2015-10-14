class UsersController < Clearance::UsersController
	# layout 'auth', :only => [:create, :new]

	def validate_beta_invite_code
		invite_code = params['invite_code'] || session['invite_code']
		if invite_code.nil?
			redirect_to '/'
			return false
		end

		beta = BetaUser.where(:invite_code => invite_code, :user_id => nil).first
		if beta.nil?
			redirect_to '/', :alert => 'Sorry, this invite code is no longer valid.'
			return false
		end

		beta
	end

	# /sign_up
	def new
		return unless validate_beta_invite_code

		# when they come in with an invite_code, store the code and redirect to url without it
		if params[:invite_code]
			session[:invite_code] = params[:invite_code]
			redirect_to '/sign_up'
		end

		@user = User.new
	end

	def create
		beta_user = validate_beta_invite_code
		return unless beta_user

		@user = user_from_params
		if @user.save
			session.delete(:invite_code)
			beta_user.user_id = @user.id
			beta_user.save
			sign_in @user
			redirect_to '/', :info => 'Thanks for signing up!'
		else
			render template: 'users/new'
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