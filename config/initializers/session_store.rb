# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_mix8_session'

Rails.application.config.session_store :cookie_store, {
	:key => '_mix8_session',
	:expire_after => 30.days,
	:domain => 'mix8.com',
	:tld_length => 2
}

