class App::SessionsController < Clearance::SessionsController
  layout '8stem'

  def destroy
    $tracker.track current_user.uuid, 'Signout: success'
    sign_out
    redirect_to url_after_destroy
  end

	def url_after_create
    $tracker.track current_user.uuid, 'Signin: via email'
    current_user.is_artist_admin? ? "#{artist_music_url}" : "#{app_home_url}?ref=signin"
	end

	def url_after_destroy
		"#{root_url}?ref=signout"
	end

	def create_from_omniauth
    @notice = ''
		auth_hash = request.env["omniauth.auth"]
		authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
		if authentication.user
			authentication.update_token(auth_hash)
      sign_in authentication.user
      $tracker.track authentication.user.uuid, 'Signin: via facebook connect'
			@next = app_home_url
    else
      logger.debug "XXX no user found for authentication"
      if signed_in?
        # signed in user is connecting to network
        current_user.authentications << authentication
        $tracker.track current_user.uuid, 'Social: connect', {'provider' => auth_hash['provider']}
        @next = app_edit_profile_path(username: current_user.username, tab: 'connections')
        @notice = 'Successfully connected'
      else
        email = auth_hash["extra"]["raw_info"]["email"]
        user = User.find_by_email(email)
        if user.nil?
          # new user account
          user = User.create_with_auth_hash(auth_hash)
          $tracker.alias user.uuid, session.id
          $tracker.track user.uuid, 'Signup: via facebook connect'
          @next = "#{app_show_profile_path(user.username)}?ref=confirm"
        else
          # user already has account, first time logging in with FB
          user.confirmed_at = Time.now if user.confirmed_at.nil?
          $tracker.track user.uuid, 'Social: connect', {'provider' => 'facebook'}
          @next = app_show_profile_path(user.username)
        end

        user.authentications << (authentication)
        logger.debug "calling sign_in for user: #{user.inspect}"
        sign_in user
      end
    end
		redirect_to @next, :notice => @notice
	end

end