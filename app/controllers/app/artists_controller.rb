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
          $tracker.alias @user.uuid, session.id
          $tracker.people.set @user.uuid, {'$name' => @user.name, '$email' => @user.email}
          $tracker.track @user.uuid, 'Artist Join: success', {'name' => @user.name, 'email' => @user.email}
          UserNotifier.account_verification_email(@user).deliver_now
          redirect_to '/artists/thanks?ref=join'
          return
        end
      rescue ActiveRecord::RecordNotUnique
        @beta_artist.errors[:email] =  "This email has already been used."
        false
      end
    else
      $tracker.track session.id, 'Artist Join: view'
      @user = User.new
    end
  end

  # allow artists to submit information for evaluation
  def apply
    if request.post?
      begin
        @beta_artist = BetaArtist.new(artist_apply_params)
        if @beta_artist.save
          $tracker.track session.id, 'Artist Apply: success', {'name' => @beta_artist.name, 'email' => @beta_artist.email}
          redirect_to '/artists/thanks?ref=apply'
          return
        end
      rescue ActiveRecord::RecordNotUnique
        @beta_artist.errors[:email] =  "This email has already been used."
        false
      end
    else
      $tracker.track session.id, 'Artist Apply: view'
      @beta_artist = BetaArtist.new
    end
  end

  def thanks
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
    params.require(:user).permit(:name, :username, :email, :password)
  end

  def artist_apply_params
    params.require(:beta_artist).permit(:artist_name, :artist_url, :name, :email, :message)
  end

end