class App::UsersController < App::BaseController
  before_action :set_profile_user, only: [:show_profile, :follow, :unfollow]

  def show_profile
  end

  def edit_profile
    @active_tab = params[:tab] || 'profile'
    redirect_to app_show_profile_path if current_user.username != params[:username]
  end

  def update_profile
    if current_user.update(profile_params)
      redirect_to app_show_profile_path, notice: 'Profile successfully updated'
    else
      @active_tab = 'profile'
      render :edit_profile
    end
  end

  def update_account
    if current_user.update(account_params)
      sign_in current_user
      redirect_to app_show_profile_path, notice: 'Account successfully updated'
    else
      @active_tab = 'account'
      render :edit_profile
    end
  end

  def follow
    current_user.follow! @user
    @user.create_activity :follow, owner: current_user
    redirect_to app_show_profile_path, notice: 'Successfully followed'
  end

  def unfollow
    current_user.unfollow! @user
    # @artist.create_activity :unfollow, owner: current_user
    redirect_to app_show_profile_path, notice: 'Successfully unfollowed'
  end

  private
  def profile_params
    params.require(:user).permit(:name, :location, :bio, :genre_list, :facebook, :instagram, :twitter, :soundcloud, :profile_image, :profile_image_cache, :profile_background_image, :profile_background_image_cache)
  end

  def account_params
    params.require(:user).permit(:email, :username, :password)
  end

  def set_profile_user
    @user = User.find_by_username(params[:username]).decorate
  end
end