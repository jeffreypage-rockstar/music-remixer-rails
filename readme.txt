# to get running
install homebrew on osx
brew install taglib
brew install imagemagick
bundle install
rake db:create db:migrate db:seed
rails s -b 127.0.0.1

# to deploy
bundle exec cap production deploy

