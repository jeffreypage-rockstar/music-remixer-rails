class App::UsersController < App::BaseController
  before_action :set_referral, except: [:thanks]
  before_action :set_profile_user, only: [:show_profile, :follow, :unfollow]

  def omniauth_failure
    redirect_to app_sign_in_url
  end

  def show_profile
  end

  def edit_profile
    @active_tab = params[:tab] || 'profile'
    redirect_to app_show_profile_path if current_user.username != params[:username]
  end

  def update_profile
    if current_user.update(profile_params)
      $tracker.track current_user.uuid, 'User: Profile updated'
      redirect_to app_show_profile_path, notice: 'Profile successfully updated'
    else
      @active_tab = 'profile'
      render :edit_profile
    end
  end

  def update_account
    if current_user.update(account_params)
      $tracker.track current_user.uuid, 'User: Account updated'
      redirect_to app_show_profile_path(current_user.username), notice: 'Account successfully updated'
    else
      @active_tab = 'account'
      render :edit_profile
    end
  end

  def follow
    current_user.follow! @user
    $tracker.track current_user.uuid, 'User: followed user', {'uuid' => @user.uuid}
    @user.create_activity :follow, owner: current_user
    redirect_to app_show_profile_path, notice: 'Successfully followed'
  end

  def unfollow
    current_user.unfollow! @user
    $tracker.track current_user.uuid, 'User: unfollowed user', {'uuid' => @user.uuid}
    # @artist.create_activity :unfollow, owner: current_user
    redirect_to app_show_profile_path, notice: 'Successfully unfollowed'
  end

  def disconnect_identity
    @user = current_user
    provider = params[:provider]
    if Authentication::PROVIDERS.include? provider
      @user.identity(provider).destroy
      $tracker.track @user.uuid, 'Social: disconnect', {'provider' => provider}
      redirect_to app_edit_profile_path(username: current_user.username, tab: 'connections'), notice: "Successfully disconnected from #{provider}"
    end
  end

  def new
    @user = User.new
    if @referral
      @user.name = @referral.name
      @user.email = @referral.email
      @user.beta_user = BetaUser.new
    end

    $tracker.track session.id, 'Signup: view'

    # todo, lets get rid of this layout!
    render :new, layout: 'signup'
  end

  def create
    user = user_params.deep_merge({ 'beta_user_attributes' => { 'invite_code' => @referral.invite_code } })
    @user = User.create(user)
    if @user.valid?
      $tracker.alias @user.uuid, session.id
      $tracker.people.set @user.uuid, {'$name' => @user.name, '$email' => @user.email}
      $tracker.track @user.uuid, 'Signup: Account created', {'name' => @user.name, 'email' => @user.email}

      @referral.update_attribute(:signed_up_at, Time.now) if @referral.email
      UserNotifier.account_verification_email(@user).deliver_now
      redirect_to "#{app_sign_up_thanks_url}?ref=signup"
    else
      render :new, layout: 'signup'
    end
  end

  def confirm
    user = User.find_by_confirmation_token(params[:confirmation_token]) if !params[:confirmation_token].blank?
    if user && user.confirmation_token == params[:confirmation_token]
      user.email_activate
      # flash[:success] = 'Welcome to the 8Stem! Your email has been confirmed. Please sign in to continue.'
      sign_in(user) do |status|
        if status.success?
          $tracker.track user.uuid, 'Signup: Account activated'
          # the ref here triggers a modal on the landing page
          redirect_to "#{app_edit_profile_url(user.username)}?ref=confirm"
        else
          $tracker.track user.uuid, 'Signup: Account activation failed'
          redirect_to "#{root_url}?ref=confirm_failure"
        end
      end
    else
      redirect_to "#{root_url}?ref=confirm_token_not_found"
    end
  end

  def thanks
    render layout: '8stem'
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

  def profile_params
    params.require(:user).permit(:name, :location, :bio, :genre_list, :facebook, :instagram, :twitter, :soundcloud, :profile_image, :profile_image_cache, :profile_background_image, :profile_background_image_cache)
  end

  def account_params
    params.require(:user).permit(:email, :username, :password)
  end

  def set_profile_user
    @user = User.find_by_username(params[:username]) or not_found
    @user = @user.decorate if @user
  end
end