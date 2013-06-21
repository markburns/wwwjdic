require 'rake'
require './db/dictionaries'

namespace :db do
  desc "Deletes and rebuilds the database, Pass in environment to select a different namespace and database integer value - Valid values development, test, production corresponding to databases 1,2 and 3 respectively"
  task :destructive_rebuild, :filename, :confirm_first, :environment do |task, args|
    defaults = { :filename => 'db/edict', :confirm_first => true , :environment => 'development'}
    args = defaults.merge args

    ENV['SINATRA_ENVIRONMENT'] = args[:environment]
    ENV["debug"] = "true"

    if args[:confirm_first]
      puts "Destructive rebuild of database. Are you sure you wish to continue? (y/n)"
      choice = STDIN.gets.strip
      exit unless choice == "y"
    end

    @dictionary = Dictionaries.new :edict => args[:filename]
    @dictionary.rebuild_database!
  end
end
