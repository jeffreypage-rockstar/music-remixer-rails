# Preview all emails at http://localhost:3000/rails/mailers/user_notifier
class UserNotifierPreview < ActionMailer::Preview

  def account_verification_email
    UserNotifier.account_verification_email(User.first)
  end

end
