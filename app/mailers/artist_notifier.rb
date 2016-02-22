class ArtistNotifier < ApplicationMailer
  default from: "Bruce Pavitt <bruce@8stem.com>"

  # Send artist account verification email
  def artist_account_verification_email(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => 'Activate your 8Stem Artist account!')
  end

  # Send artist invite email
  def artist_invite_to_join_email(beta_artist)
    @beta_artist = beta_artist
    mail(:to => "#{@beta_artist.name} <#{@beta_artist.email}>", :subject => 'Hello from 8Stem')
  end
end
