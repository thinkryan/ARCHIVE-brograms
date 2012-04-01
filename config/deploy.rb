require "bundler/capistrano"

set :application, 'brograms'
set :repository,  "git@github.com:zurb/brograms.git"

set :deploy_via, :remote_cache
set :scm, "git"
set :use_sudo, false
set :user, application

set :deploy_to, "/var/www/#{application}"
set :rails_env, 'production'
server = "brogra.ms"

#use local key for authentication
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

default_environment['PATH'] = "/opt/ree/bin:$PATH"

role :app, server
role :web, server
role :db, server, :primary => true

after "deploy:update_code", "deploy:link_config_files"
namespace :deploy do
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      result = File.read(File.join(File.dirname(__FILE__), "..", "app", "views", "index", "maintenance.rhtml"))

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
  
  task :link_config_files do
    %w{database smtp_settings}.each do |file_name|
      run "ln -nfs #{shared_path}/config/#{file_name}.yml #{release_path}/config/#{file_name}.yml"
    end
  end
end