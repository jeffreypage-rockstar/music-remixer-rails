Clearance.configure do |config|
  config.routes = false

	# TODO: change mailer sender email address
  config.mailer_sender = "mark@8stem.com"

  # Clearance::SessionsController.layout 'auth'
  # Clearance::SessionsController.layout 'auth'
  # Clearance::UsersController.layout 'auth'
  # Clearance.configuration.redirect_url = '/artist/dashboard'
end
