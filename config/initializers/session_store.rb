# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, {
  :key => '_8stem_session',
  :expire_after => 90.days,
  :domain => Rails.env.production? ? '.8stem.com' : (Rails.env.staging? ? '.mix8.com' : '.mix8.dev'),
  :tld_length => 2
}

