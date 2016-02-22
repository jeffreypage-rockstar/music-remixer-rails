#web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
web: bundle exec rails s -b 127.0.0.1

# See config/unicorn.rb for disabling spawing of workers in web dyno
#worker: bundle exec sidekiq -C config/sidekiq.yml
worker: bundle exec sidekiq -q carrierwave


