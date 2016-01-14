class App::PasswordsController < App::BaseController
  before_action :require_login, :only => []
  layout '8stem'

  def new
  end

  def edit
    @user = User.find_by_confirmation_token(params[:token])
    if @user.nil?
      flash.now[:notice] = 'You will receive an email within the next few minutes. It contains instructions for changing your password.'
      render template: 'app/passwords/new'
      redirect_to
    end
  end

  def create
    if user = User.find_by_email(params[:password][:email])
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

  def reset_password_success_modal
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