require 'rubygems'
require 'bundler'
Bundler.setup

require 'ruby-debug'
Debugger.start_remote
Debugger.settings[:autoeval] = true
puts "=> Debugger enabled"

require 'sinatra'
require './wwwjdic'

require File.join(File.dirname(__FILE__), 'wwwjdic.rb')
run Wwwjdic
