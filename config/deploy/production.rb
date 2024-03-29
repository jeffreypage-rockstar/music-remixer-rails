# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server '104.130.173.100', user: 'deploy', roles: %w{app}
server '104.130.173.100', user: 'deploy', roles: %w{web}
server '104.130.173.100', user: 'deploy', roles: %w{db}  # migrations are run from web1


# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any  hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

# role :app, %w{deploy@example.com}, my_property: :my_value
# role :web, %w{user1@primary.com user2@additional.com}, other_property: :other_value
# role :db,  %w{deploy@example.com}



# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.
#set :deploy_to, '/var/deploy/akashic'
# set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }
#set :rvm_ruby_string, 'ruby 2.2.1p85'
#set :rvm_type, :system
# set :rvm_custom_path, '/home/ubuntu/.rvm'  # only needed if not detected

set :application, '8stem'
set :branch, "master"
set :deploy_to, '/home/deploy/8stem'

set :stage, :production
set :rails_env, "production"

set :rollbar_token, 'd1f50300ea374553b47c73471ef2fa80' # 8stem token

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
# set :ssh_options, {
#   verbose: :debug,
#   keys: %w(~/.ssh/id_rsa.pub),
#   forward_agent: true,
#   auth_methods: %w(password)
# }
#
# The server-based syntax can be used to override options:
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }

set :sidekiq_role, :app
set :sidekiq_env, 'production'
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
