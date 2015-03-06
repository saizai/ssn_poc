# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :rvm_ruby_string, 'ruby-2.2.0'

set :application, 'ssn_poc'  # Required

set :ci_client, 'travis'
set :ci_repository, 'saizai/ssn_poc'

set :scm, :git # :git, :darcs, :subversion, :cvs
set :repo_url, 'git://github.com/saizai/ssn_poc.git'
set :branch, 'master'
set :git_enable_submodules, 1

# set :gateway, "gate.host.com"  # default to no gateway
set :runner, 'saizai_ssn'
set :group, 'pg886808'
set :deploy_to, '/home/saizai_ssn/ssn.s.ai/' # must be path from root
set :deploy_via, :remote_cache

set :rails_env, 'production'

set :ssh_options,
    user:          'saizai_ssn',
    compression:   false,
    # keys:  %w(~/.ssh/myl_deploy),
    forward_agent: true # make sure you have an SSH agent running locally
# auth_methods: %w(password)
# port: 25

server 'ssn.s.ai', roles: [:web, :app, :db]

# set :workers,  '*' => 2

# Uncomment this line if your workers need access to the Rails environment:
# set :resque_environment_task, true

# set :format, :pretty
# set :log_level, :debug
set :pty, true  # turning on pty allows resque workers to be started without making capistrano hang

# set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system
                      public/assets public/files db/data config/keys)

set :keep_releases, 15

# not cap3 compatible yet https://github.com/railsware/capistrano-ci/pull/4
# before :deploy, "ci:verify"

namespace :deploy do
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within fetch(:release_path) do
        execute :touch, "tmp/restart.txt"
      end
    end
  end

  desc "Set permissions on shared folders"
  task :set_permissions do
    on roles(:web) do
      # execute "chmod -R u=rwX,g=rX,o= #{shared_path}/"
      # execute "chmod o=rX #{shared_path}/"
      # execute "chmod -R o=rX #{shared_path}/public/"

      ['bin', 'bundle', 'config', 'db', 'log', 'tmp', 'tmp/cache', 'tmp/pids', 'vendor', 'vendor/bundle'].each do |i|
        execute "chmod 2751 #{shared_path}/#{i}"
      end
      ['tmp/sockets', 'tmp/sockets/*.sock'].each do |i|
        execute "chmod 2770 #{shared_path}/#{i}"
      end
      execute "chmod 2755 #{shared_path}/public"
    end
  end

  before :finishing, 'deploy:set_permissions'

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
  # after :finishing, 'airbrake:deploy'

  # # https://github.com/capistrano/capistrano/issues/478#issuecomment-24983528
  # namespace :assets do
  #   task :update_asset_mtimes, :roles => lambda { assets_role },
  #                              :except => { :no_release => true } do
  #   end
  # end
  # set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

  task :down do
    on roles(:app) do
      execute :mv, "#{release_path}/public/maintenance_standby.html",
              "#{release_path}/public/maintenance.html"
    end
  end
  task :up do
    on roles(:app) do
      execute :mv, "#{release_path}/public/maintenance.html",
              "#{release_path}/public/maintenance_standby.html"
    end
  end
end

require './config/boot'
