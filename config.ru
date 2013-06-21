require 'rubygems'
require 'bundler'
Bundler.setup

if ENV['debug']
  require 'ruby-debug'
  Debugger.start_remote
  Debugger.settings[:autoeval] = true
  puts "=> Debugger enabled"
end

require './wwwjdic'

run Wwwjdic
