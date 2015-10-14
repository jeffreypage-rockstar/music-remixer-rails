source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'

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
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Bootsrap for user interface
gem 'bootstrap-sass', '~> 3.3.1'
gem 'font-awesome-rails', '~> 4.4.0.0'
gem 'autoprefixer-rails'

# authentication
gem 'clearance', '~> 1.11'

# admin
gem 'rails_admin'

# easy forms
gem 'simple_form'

# Table generator
# gem 'simple_table_for'

# Upload file
gem 'carrierwave'

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

  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-ext',     require: false
  gem 'capistrano-faster-assets', '~> 1.0.2'
  gem 'capistrano3-unicorn', require: false
end

group :production do
	gem 'pg', '~> 0.18.3'
  gem 'unicorn'  
end

gem 'taglib-ruby', '~> 0.7.0'
gem 'jquery-ui-rails', '~> 5.0.5'
