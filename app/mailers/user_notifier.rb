class UserNotifier < ApplicationMailer
  default from: "beta@8stem.com"

  # Send the beta migration email
  def beta_migration_email(email)

    mail(to: email,
         subject: '8Stem Beta Test')
  end

  # Send account verification email
  def account_verification_email(user)

    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Activate your 8Stem account!')
  end

  # Send reset password email
  def reset_password_email(user)

    @user = user
    mail(to: user.email,
         subject: 'Reset your 8Stem password')
  end
end
