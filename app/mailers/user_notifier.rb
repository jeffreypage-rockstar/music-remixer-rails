class UserNotifier < ApplicationMailer
  default from: "Beta Team <beta@8stem.com>"
  layout false, :only => ['beta_migration_email', 'account_verification_email']

  # Send the beta migration email
  def beta_migration_email(referral)
    @referral = referral
    substitute '-user_name-', @referral.name
    substitute '-signup_url-', app_referral_invite_url(@referral.invite_code)
    add_filter_setting 'templates', 'enable', 1
    add_filter_setting 'templates', 'template_id', '522e97d6-62af-4c0c-bef8-16a31ec5f879'
    mail(:to => "#{@referral.name} <#{@referral.email}>", :subject => 'Complete Your Sign-up')
  end

  # Send account verification email
  def account_verification_email(user)
    @user = user
    substitute '-user_name-', @user.name
    substitute '-verification_url-', confirm_app_users_url(confirmation_token: @user.confirmation_token)
    add_filter_setting 'templates', 'enable', 1
    add_filter_setting 'templates', 'template_id', 'd66fca3e-37ca-42b8-aee1-66a5ea4079c3'
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Activate your 8Stem account!')
  end

  # Send reset password email
  def reset_password_email(user)
    @user = user
    mail(:to => user.email, :subject => 'Reset your 8Stem password')
  end

end
