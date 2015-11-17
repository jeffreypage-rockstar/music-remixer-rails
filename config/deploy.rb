# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'mix8'

set :repo_url, 'git@bitbucket.org:8stem/akashic-nga.git'
set :deploy_via, :remote_cache
set :branch, "master"

set :rbenv_type, :user
set :rbenv_ruby, '2.2.3'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

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
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
after 'deploy', 'deploy:cleanup'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
	# %w[start stop restart].each do |command|
	# 	desc "#{command} unicorn server"
	# 	task command do
	# 		on roles :web do
	# 			run "/etc/init.d/unicorn_#{application} #{command}"
	# 		end
	# 	end
	# end

	# task :setup_config do
	# 	on roles :web do
	# 		sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
	# 		sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
	# 		run "mkdir -p #{shared_path}/config"
	# 		put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
	# 		puts "Now edit #{shared_path}/config/database.yml and add your username and password"
	# 	end
	# end
	# # after "deploy:setup", "deploy:setup_config"

	# desc "Make sure local git is in sync with remote."
	# task :check_revision do
	# 	on roles :web do
	# 		unless `git rev-parse HEAD` == `git rev-parse origin/master`
	# 			puts "WARNING: HEAD is not the same as origin/master"
	# 			puts "Run `git push` to sync changes."
	# 			exit
	# 		end
	# 	end
	# end
	# before "deploy", "deploy:check_revision"
end
