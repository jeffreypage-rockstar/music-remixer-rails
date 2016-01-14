class App::SessionsController < Clearance::SessionsController
  layout '8stem'

	def url_after_create
    current_user.is_artist_admin? ? "#{artist_music_url}" : "#{app_home_url}?ref=signin"
	end

	def url_after_destroy
		"#{root_url}?ref=signout"
	end

	def create_from_omniauth
		auth_hash = request.env["omniauth.auth"]
		authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
		if authentication.user
			user = authentication.user
			authentication.update_token(auth_hash)
			@next = root_url
			@notice = "Signed in!"
		else
			if signed_in?
				current_user.authentications << authentication
				@next = app_edit_profile_path(tab: 'connections')
				@notice = 'Successfully connected'
			else
				user = User.create_with_auth_and_hash(authentication, auth_hash)
				# TODO: @next should be the user profile edit page (didn't exist yet when this was added)
				@next = app_profile_path(user)
				@notice = "User created - confirm or edit details..."
				puts "calling sign_in for user: #{user.inspect}"
				sign_in user
			end
		end
		redirect_to @next, :notice => @notice
	end

end