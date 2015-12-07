class UsersController < Clearance::UsersController
	def new
		@user = User.new
		render :new, layout: 'signup'
	end

	def create
		user = { invite_only: true }.merge(user_params)
		@user = User.new(user)
		if @user.save
			beta_user = BetaUser.find_by(invite_code: user[:invite_code], user_id: nil)
			beta_user.user_id = @user.id
			beta_user.save
			sign_in @user
			redirect_to '/', :info => 'Thanks for signing up!'
		else
			render :new, layout: 'signup'
		end
	end

	private

	def user_params
		params.require(:user).permit(:name, :username, :email, :password, :invite_code)
	end

end