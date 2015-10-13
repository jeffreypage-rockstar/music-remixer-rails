class SessionsController < Clearance::SessionsController
	# layout 'auth'

	def url_after_create
		url = current_user.is_artist_admin ? '/artist/dashboard' : '/'
		"#{url}?ref=signin"
	end

	def url_after_destroy
		'/?ref=signout'
	end
end