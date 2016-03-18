source 'https://rubygems.org'

ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'

gem 'mysql2', '~> 0.3.18'
#gem 'mysql2', '~> 0.4.1' #no workie with this version of rails

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'rubyzip',  "~> 1.1", require: 'zip'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# 3rd party gems
gem 'event_tracker'
gem 'mixpanel-ruby'
gem 'rollbar', '~> 2.5.0'

# Bootsrap for user interface
gem 'bootstrap-sass', '~> 3.3.1'
gem 'font-awesome-rails', '~> 4.4.0.0'
gem 'autoprefixer-rails'

# authentication
gem 'clearance', '~> 1.11'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-soundcloud'

# admin
gem 'rails_admin'

# todo: why do we have this gem?
gem 'sinatra', require: nil

# Workers
gem 'sidekiq'

# easy forms
gem 'simple_form'

# public activity stream
gem 'public_activity', github: 'pokonski/public_activity'

# likes, follows, mentions
gem 'socialization', '~> 1.2.0'

# tagging for song/artist genres
gem 'acts-as-taggable-on', '~> 3.4'

# commenting
gem 'acts_as_commentable_with_threading'

# auto-linking
gem 'rails_autolink'

# Table generator
# gem 'simple_table_for'

# Upload file
gem 'carrierwave'
gem 'carrierwave_backgrounder'

gem 'fog'
gem 'mini_magick'
gem 'cocaine'

gem 'slim-rails'
gem 'draper'
gem 'responders'

# authorization -- todo: why pundit too?
gem 'pundit'

# copy to clipboard
gem 'zeroclipboard-rails'

gem 'dropzonejs-rails'

# pagination
gem 'kaminari'

# default value
gem 'default_value_for'

gem 'jquery-fileupload-rails'

# rest apis
gem 'rack-cors', require: 'rack/cors'
gem 'grape'
gem 'grape-swagger', '~> 0.10.4'
gem 'grape-swagger-rails'
gem 'grape-entity'
gem 'grape-kaminari'
gem 'hashie-forbidden_attributes'

# facebook library
gem 'koala'

# ffmpeg
gem 'streamio-ffmpeg'

# sendgrid
gem 'sendgrid-rails', '~> 2.0'

# mailkick
gem 'mailkick'

# DynamicForm
gem "dynamic_form"

# Premailer
gem 'premailer-rails'

# Nokogiri
gem 'nokogiri'

group :development, :test do
  gem 'puma'
  
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'quiet_assets'

  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-ext',     require: false
  gem 'capistrano-faster-assets', '~> 1.0.2'
  gem 'capistrano-rbenv', github: 'capistrano/rbenv'
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end

group :production do
  gem 'unicorn'  
end
