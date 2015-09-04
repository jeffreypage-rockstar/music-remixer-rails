root = "/var/deploy/akashic/current"
shared_dir = "#{root}/shared"
working_directory root

pid "#{shared_dir}/tmp/pids/unicorn.pid"

stderr_path "#{shared_dir}/log/unicorn.access.log"
stdout_path "#{shared_dir}/log/unicorn.error.log"

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
timeout 30
preload_app true

listen '/tmp/unicorn.akashic.sock', backlog: 64

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(root, 'Gemfile')
end