class App::PasswordsController < App::BaseController
  before_action :require_login, :only => []
  layout '8stem'

  def new
    track_event 'PasswordReset: view'
  end

  def edit
    @user = User.find_by_confirmation_token(params[:token])
    if @user.nil?
      flash.now[:notice] = 'You will receive an email within the next few minutes. It contains instructions for changing your password.'
      render template: 'app/passwords/new'
      redirect_to
    else
      track_event 'PasswordReset: reset email clicked', {'email' => @user.email}
    end
  end

  def create
    if user = User.find_by_email(params[:password][:email])
      track_event 'PasswordReset: reset attempt', {'email' => user.email}
      user.forgot_password!
      deliver_email(user)
    end
    flash.now[:notice] = 'You will receive an email within the next few minutes. It contains instructions for changing your password.'
    render template: 'app/passwords/new'
  end

  def update
    @user = User.find_by_confirmation_token(params[:token])
    if @user.update(password_reset_params)
      respond_to do |format|
        format.js { render :update }
      end
    else
      flash_failure_after_update
      render template: 'app/passwords/edit'
    end
  end

  def resend_confirmation
    if user = User.find_by_email(params[:sessions][:email])
      UserNotifier.account_verification_email(user).deliver_now
    end
    flash[:notice] = 'You will receive a new confirmation email within the next few minutes.'
    redirect_to app_sign_in_path
  end

  def reset_password_success_modal
    track_event 'PasswordReset: success'
    render layout: 'modal'
  end

  def deliver_email(user)
    UserNotifier.reset_password_email(user).deliver_now
  end

  private

  def password_reset_params
    params.require(:password_reset).permit(:password)
  end

end