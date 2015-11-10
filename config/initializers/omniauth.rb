Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, '1519009081750998', '45c00ac7fe9f421588d9fdffe07d24b1'
	# provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], scope: 'public_profile', info_fields: 'id,name,link'
end
