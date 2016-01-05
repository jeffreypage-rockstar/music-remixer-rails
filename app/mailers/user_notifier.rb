class UserNotifier < ApplicationMailer
  default from: "beta@8stem.com"

  # send the beta migration email
  def beta_migration_email(email)

    mail(to: email,
         subject: '8Stem Beta Test')
  end

  def account_verification_email(user)

    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Activate your 8Stem account!')
  end

  def reset_password_email(user)

    @user = user
    mail(to: user.email,
         subject: 'Reset your 8Stem password')
  end
end
