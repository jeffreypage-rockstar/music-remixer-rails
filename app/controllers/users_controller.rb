class UsersController < Clearance::UsersController
	before_action :set_referral, except: [:thanks]

	def new
		@user = User.new(name: @referral.name, email: @referral.email, beta_user: BetaUser.new)
		render :new, layout: 'signup'
	end

	def create
		user = user_params.deep_merge({ 'beta_user_attributes' => { 'invite_code' => @referral.invite_code } })
		@user = User.new(user)
		if @user.save
      @referral.update_attribute(:signed_up_at, Time.now)
			sign_in @user
			redirect_to '/', info: 'Thanks for signing up!'
		else
			render :new, layout: 'signup'
		end
	end

	private
  def set_referral
    if params[:invite_code]
      referral = Referral.virgin.find_by(invite_code: params[:invite_code])
      @referral = referral if referral
    end

    redirect_to root_path, alert: 'Invalid invite code or already occupied.' if @referral.nil?
  end

	def user_params
		user = params.require(:user).permit(:name, :username, :email, :password, beta_user_attributes: [:phone_type, :music_background, :message])
    user[:beta_user_attributes][:name] = user[:name]
    user[:beta_user_attributes][:email] = user[:email]
    user
  end

end