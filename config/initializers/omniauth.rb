Rails.application.config.middleware.use OmniAuth::Builder do
	# my mix8 - Dev
	# provider :facebook, '853550408064609', '3e395df5bea7696742cb192c60848f53'

	# 8stem - Dev
	provider :facebook, Rails.application.secrets.facebook_key, Rails.application.secrets.facebook_secret, provider_ignores_state: true

	# from Adam
	# provider :facebook, '1519009081750998', '45c00ac7fe9f421588d9fdffe07d24b1'

	# TOOD for production
	# provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], scope: 'public_profile', info_fields: 'id,name,link'
end
