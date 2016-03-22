class App::ArtistsController < App::BaseController
  layout 'artist_signup'

  # artist signup
  def join
    # if @referral
    #   @user.name = @referral.name
    #   @user.email = @referral.email
    #   @user.beta_user = BetaUser.new
    # end
    if request.post?
      @user = User.new(artist_join_params)
      begin
        if @user.save
          mixpanel_alias @user.uuid
          mixpanel_people_set({'$name' => @user.name, '$email' => @user.email, '$username' => @user.username})
          track_event 'Artist Join: success', {'name' => @user.name, 'email' => @user.email}
          ArtistNotifier.artist_account_verification_email(@user).deliver_now
          redirect_to "#{app_artists_thanks_url}?ref=join"
          return
        end
      rescue ActiveRecord::RecordNotUnique
        @beta_artist.errors[:email] =  "This email has already been used."
        false
      end
    else
      if params[:invite_code]
        beta_artist = BetaArtist.find_by(invite_code: params[:invite_code])
        if beta_artist
          @user = User.new
          @user.name = beta_artist.artist_name
          @user.email = beta_artist.email
          track_event 'Artist join: view'
          return
        end
      end
      # no valid invite_code, no go
      redirect_to "#{app_artists_apply_url}?ref=join"
    end
  end

  # allow artists to submit information for evaluation
  def apply
    if request.post?
      begin
        @beta_artist = BetaArtist.new(artist_apply_params)
        if @beta_artist.save
          track_event 'Artist Application: success', {'name' => @beta_artist.name, 'email' => @beta_artist.email}
          redirect_to "#{app_artists_thanks_url}?ref=apply"
          return
        end
      rescue ActiveRecord::RecordNotUnique
        @beta_artist.errors[:email] =  "This email has already been used."
        false
      end
    else
      track_event 'Artist Application: view'
      @beta_artist = BetaArtist.new
    end
  end

  def thanks
  end

  # similar to user confirm, just with 'artist' stuff
  def confirm
    user = User.find_by_confirmation_token(params[:confirmation_token])
    if user && user.confirmation_token == params[:confirmation_token]
      user.email_activate
      sign_in(user) do |status|
        if status.success?
          track_event 'Artist Signup: account activated'
          # the ref here triggers a modal on the landing page
          redirect_to "#{app_edit_profile_url(user.username)}?ref=artist_confirm"
        else
          track_event 'Artist Signup: activation failed'
          redirect_to "#{root_url}?ref=artist_confirm_failure"
        end
      end
    else
      redirect_to "#{root_url}?ref=artist_confirm_token_not_found"
    end
  end

  private

  def set_referral
    @referral = Referral.new
    if params[:invite_code]
      referral = Referral.virgin.find_by(invite_code: params[:invite_code])
      @referral = referral if referral
    end
  end

  def artist_join_params
    artist = params.require(:user).permit(:name, :username, :email, :password, :terms_of_service)
    artist[:is_artist_admin] = true
    artist
  end

  def artist_apply_params
    params.require(:beta_artist).permit(:artist_name, :artist_url, :name, :email, :message)
  end

end