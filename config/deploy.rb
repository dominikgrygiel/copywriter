# -*- encoding : utf-8 -*-
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'open-uri'

set :rvm_ruby_string, "1.9.2-p290"
set :rvm_type, :system

set :rails_env, stage
set :application, "copywriter"
set :repository,  "git@bitbucket.org:dominikgrygiel/#{application}.git"

set :scm, :git

set :gateway, "deploy@n1.ihoshi.pl"
set :webserver, "n1.ihoshi.pl"

set :user, application
set :deploy_to, "/home/#{user}/app"

branches = {:production => :master}
set(:branch) { branches[fetch(:stage).to_sym].to_s }

server webserver, :app, :web, :db, :primary => true

set :remote, "origin"
set(:current_revision)  { capture("cd #{current_path}; git rev-parse HEAD").strip }

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:runner) { "RAILS_ENV=#{fetch(:stage)} bundle exec" }

namespace :deploy do
  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')} && chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
    run "cd #{current_path} && git checkout -b #{stage} ; git merge #{remote}/#{branch}; git push #{remote} #{stage}"

    #symlink vendor/bundle
    run("mkdir #{shared_path}/bundle")
    run("ln -s #{shared_path}/bundle #{current_path}/vendor/bundle")
  end

  desc "Deploy the MFer"
  task :default do
    update
    migrate
    restart
  end

  desc "Update code"
  task :update do
    transaction do
      update_code
    end
  end

  desc "Run migrations"
  task :migrate do
    run("cd #{current_path} && #{runner} rake db:migrate ")
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path} && git fetch #{remote} && git checkout #{stage} -f && git merge #{remote}/#{branch} && git push #{remote} #{stage}"
    finalize_update
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code" do
  run "cd #{current_path} && #{runner} rake assets:precompile"
end

after "deploy:restart" do
  run "curl http://copywriter.ihoshi.pl/ > /dev/null 2> /dev/null"
end

