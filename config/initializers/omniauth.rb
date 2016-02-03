Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,   Rails.application.secrets.facebook_key,   Rails.application.secrets.facebook_secret, provider_ignores_state: true
  provider :twitter,    Rails.application.secrets.twitter_key,    Rails.application.secrets.twitter_secret, provider_ignores_state: true
  provider :soundcloud, Rails.application.secrets.soundcloud_key, Rails.application.secrets.soundcloud_secret, provider_ignores_state: true
end
