# this one from here: http://www.andrewgertig.com/setting-up-a-digital-ocean-droplet-vps-on-ubuntu-with-rails-nginx-unicorn-postgres-redis-and-capistrano

# root = "/home/deploy/mix8/current"
# working_directory root
# pid "#{root}/tmp/pids/unicorn.pid"
# stderr_path "#{root}/log/unicorn.log"
# stdout_path "#{root}/log/unicorn.log"
#
# listen "/tmp/unicorn.mix8.sock"
# worker_processes 2
# timeout 30
#
# # Force the bundler gemfile environment variable to
# # reference the capistrano "current" symlink
# before_exec do |_|
#   ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
# end


# this one from here: https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-unicorn-and-nginx-on-ubuntu-14-04

# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/../../shared"
working_directory app_dir


# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Set up socket location
listen "#{shared_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/tmp/pids/unicorn.pid"
