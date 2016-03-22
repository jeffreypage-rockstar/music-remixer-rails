class App::SessionsController < Clearance::SessionsController
  layout '8stem'

  def new
    track_event 'Signin: view'
    unless params[:backto].blank?
      session[:backto] = params[:backto]
    end
  end

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash.now.notice = status.failure_message
        render template: "app/sessions/new", status: :unauthorized
      end
    end
  end

  def destroy
    track_event 'Signout' if current_user
    sign_out
    redirect_to url_after_destroy
  end

	def url_after_create
    track_event 'Signin: via email'
    # mixpanel_identify current_user.uuid
    mixpanel_people_set({'$name' => current_user.name, '$email' => current_user.email, '$username' => current_user.username})
    unless session[:backto].nil?
      url = session[:backto]
      session[:backto] = nil
      return "#{url}?ref=signin"
    end
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
      user = authentication.user
      sign_in user
      # mixpanel_identify user.uuid
      mixpanel_people_set({'$name' => user.name, '$email' => user.email, '$username' => user.username})
      track_event 'Signin: via facebook connect', {'name' => user.name, 'email' => user.email}
      @next = app_home_url
    else
      if signed_in?
        # signed in user is connecting to network
        current_user.authentications << authentication
        track_event 'Social: connect', {'name' => current_user.name, 'email' => current_user.email, 'provider' => auth_hash['provider']}
        @next = app_edit_profile_path(username: current_user.username, tab: 'connections')
        @notice = 'Successfully connected'
      else
        email = auth_hash["extra"]["raw_info"]["email"]
        user = User.find_by_email(email)
        if user.nil?
          # new user account
          user = User.create_with_auth_hash(auth_hash)
          mixpanel_alias user.uuid
          mixpanel_people_set({'$name' => user.name, '$email' => user.email, '$username' => user.username})
          track_event 'Signup: via facebook connect', {'name' => user.name, 'email' => user.email}
          @next = "#{app_show_profile_path(user.username)}?ref=confirm"
        else
          # user already has account, first time logging in with FB
          user.confirmed_at = Time.now if user.confirmed_at.nil?
          track_event 'Social: connect', {'name' => current_user.name, 'email' => current_user.email, 'provider' => 'facebook'}
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