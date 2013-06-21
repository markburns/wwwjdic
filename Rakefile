#Taken straight from the source code for Resque
#https://raw.github.com/defunkt/resque/9b4b900fabc65e59f5ab158a00c47c401de2ae8f/Rakefile

# Setup
#

load './lib/tasks/redis.rake'
load './lib/tasks/cucumber.rake'
load './lib/tasks/dictionary.rake'

$LOAD_PATH.unshift 'lib'

def command?(command)
  system("type #{command} > /dev/null 2>&1")
end


task :install => [ 'redis:install', 'dtach:install' ]
