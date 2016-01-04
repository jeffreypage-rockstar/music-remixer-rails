class PasswordsController < Clearance::PasswordsController
  layout '8stem'

  def create
    if user = find_user_for_create
      user.forgot_password!
      deliver_email(user)
    end
    flash.now[:notice] = 'You will receive an email within the next few minutes. It contains instructions for changing your password.'
    render template: 'passwords/new'
  end

  def update
    @user = find_user_for_update

    if @user.update_password password_reset_params
      respond_to do |format|
        format.js
      end
    else
      flash_failure_after_update
      render template: 'passwords/edit'
    end
  end

  def reset_password_success_modal
    render layout: 'modal'
  end
  def deliver_email(user)
    UserNotifier.reset_password_email(user).deliver_now
  end
end