# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "timetoanswer"
set :repo_url, 'https://github.com/araujoG/time_to_answer.git' # repositório git do seu projeto
set :deploy_to, '/var/www/timetoanswer'
set :branch, "main"
set :keep_releases, 5
set :format, :airbrussh
set :log_level, :debug
append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "storage", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
