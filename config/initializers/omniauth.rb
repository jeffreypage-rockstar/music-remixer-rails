Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,   Rails.application.secrets.facebook_key,   Rails.application.secrets.facebook_secret,
           :scope => 'email,public_profile',
           :info_fields => 'email,name',
           :display => 'popup'
  provider :twitter,    Rails.application.secrets.twitter_key,    Rails.application.secrets.twitter_secret, provider_ignores_state: true
  provider :soundcloud, Rails.application.secrets.soundcloud_key, Rails.application.secrets.soundcloud_secret, provider_ignores_state: true
end
