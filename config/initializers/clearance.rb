Clearance.configure do |config|
  config.routes = false
  config.cookie_domain = Rails.env.production? ? '.mix8.com' : '.mix8.dev'
  config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
  config.cookie_name = 'remember_token'
  config.cookie_path = '/'

	# TODO: change mailer sender email address
  config.mailer_sender = "mark@8stem.com"

  # Clearance::SessionsController.layout 'auth'
  # Clearance::SessionsController.layout 'auth'
  # Clearance::UsersController.layout 'auth'
  # Clearance.configuration.redirect_url = '/artist/dashboard'

	# TODO: do we really want this email confirmation guard?
	# it makes fb connect not work
  # config.sign_in_guards = [EmailConfirmationGuard]
end
