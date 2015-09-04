root = "/var/deploy/akashic"
current_dir = "#{root}/current"
shared_dir = "#{root}/shared"

working_directory current_dir

pid "#{current_dir}/tmp/pids/unicorn.pid"

stderr_path "#{shared_dir}/log/unicorn.error.log"
stdout_path "#{shared_dir}/log/unicorn.access.log"

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
timeout 30
preload_app true

listen '/tmp/unicorn.akashic.sock', backlog: 64

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{current_dir}/Gemfile"
end

# preload
preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end