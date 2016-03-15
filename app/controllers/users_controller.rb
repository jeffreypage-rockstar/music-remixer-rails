class UsersController < Clearance::UsersController
  def omniauth_failure
    redirect_to app_sign_in_url
  end
end