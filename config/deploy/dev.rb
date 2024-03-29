load 'deploy/assets'

set :user, 'wangsy'
set :domain, "steve"
set :deploy_to, "/home/#{user}/www/#{application}"

set :application, 'mintoffice'
set :rvm_ruby_string, 'ruby-1.9.3-head'
set :rvm_type, :user
require "rvm/capistrano"

require "bundler/capistrano"

set :repository,  "git@mintech.kr:#{application}.git"
set :scm, :git
set :branch, 'develop'
set :scm_verbose, true
set :deploy_via, :copy
set :copy_strategy, :export

set :use_sudo, false

set :port, 22
ssh_options[:forward_agent] = true

server "steve", :app, :web, :db, :primary => true

set :rails_env, "dev"
set :unicorn_env, :dev
require "capistrano-unicorn"

namespace :deploy do
  task :relink_directories, :roles => :app do
    #run "mkdir -p #{release_path}/tmp/sockets"
    run "if [ -e #{deploy_to}/shared/database.yml ]; then cp #{deploy_to}/shared/database.yml #{release_path}/config/; fi"
    run "if [ -e #{deploy_to}/shared/oauth_key.yml ]; then cp #{deploy_to}/shared/oauth_key.yml #{release_path}/config/; fi"
    run "if [ -e #{deploy_to}/shared/google_apps.yml ]; then cp #{deploy_to}/shared/google_apps.yml #{release_path}/config/; fi"
    run "if [ -e #{deploy_to}/shared/mail_configure.rb ]; then cp #{deploy_to}/shared/mail_configure.rb #{release_path}/config/initializers/; fi"
    run "if [ -e #{deploy_to}/shared/application.js ]; then cp #{deploy_to}/shared/application.js #{release_path}/app/assets/javascripts/; fi"
    run "ln -sf #{deploy_to}/shared/files #{release_path}/"
  end

  before 'deploy:finalize_update', 'deploy:relink_directories'
end

namespace :unicorn do
  task :reload, :roles => :app do
    stop
    sleep 5
    start
  end
end

after 'deploy:restart', 'unicorn:reload'