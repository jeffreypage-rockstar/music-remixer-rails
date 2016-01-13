# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mix8'

set :repo_url, 'git@bitbucket.org:8stem/akashic-nga.git'
set :deploy_via, :remote_cache
set :branch, "master"

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_path, '/home/deploy/.rbenv/'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/mix8'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

set :use_sudo, false
set :bundle_binstubs, nil

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
after 'deploy', 'deploy:cleanup'
after 'deploy', 'deploy:restart_daemons'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
  end
  task :restart_daemons, :roles => :app do
    sudo 'monit restart all -g daemons'
  end
end
