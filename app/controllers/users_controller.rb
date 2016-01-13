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
		@user = User.create(user)
		if @user.valid?
      @referral.update_attribute(:signed_up_at, Time.now) if @referral.email
      UserNotifier.account_verification_email(@user).deliver_now
      render :create_success, layout: '8stem'
		else
			render :new, layout: 'signup'
		end
  end

  def confirm_email
    user = User.find_by_confirmation_token(params[:confirmation_token])
    if user && user.confirmation_token == params[:confirmation_token]
      user.email_activate
      # flash[:success] = 'Welcome to the 8Stem! Your email has been confirmed. Please sign in to continue.'
      sign_in(user) do |status|
        if status.success?
          redirect_back_or "/#{user.username}/edit?ref=verification"
        else
          flash.now.notice = status.failure_message
          render template: 'sessions/new', status: :unauthorized
        end
      end
    else
      flash[:error] = 'Sorry. User does not exist'
      redirect_to root_url
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
		user = params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :terms_of_service, beta_user_attributes: [:age, :phone_type, :music_background_ids => []])
    user[:beta_user_attributes][:name] = user[:name]
    user[:beta_user_attributes][:email] = user[:email]
    user
  end
end