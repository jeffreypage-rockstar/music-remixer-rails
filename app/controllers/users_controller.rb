class UsersController < Clearance::UsersController
	before_action :set_referral, except: [:thanks]

	def new
    @user = User.new

    if @referral
      @user.name = @referral.name
      @user.email = @referral.email
      @user.beta_user = BetaUser.new
    end

		render :new, layout: 'signup'
	end

	def create
		user = user_params.deep_merge({ 'beta_user_attributes' => { 'invite_code' => @referral.invite_code } })
		@user = User.new(user)
		if @user.save
      puts "XXX referral: #{@referral.inspect}"
      @referral.update_attribute(:signed_up_at, Time.now) if @referral.email
			sign_in @user
			redirect_to '/?thanks', info: 'Thanks for signing up!'
		else
			render :new, layout: 'signup'
		end
  end

  def thanks
  end

	private
  def set_referral
    @referral = Referral.new
    if params[:invite_code]
      referral = Referral.virgin.find_by(invite_code: params[:invite_code])
      @referral = referral if referral
    end
  end

	def user_params
		user = params.require(:user).permit(:name, :username, :email, :password, beta_user_attributes: [:phone_type, :music_background, :message])
    user[:beta_user_attributes][:name] = user[:name]
    user[:beta_user_attributes][:email] = user[:email]
    user
  end

end