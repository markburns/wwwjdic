source "https://rubygems.org"
require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

gem 'sinatra'
gem 'rack-conneg'

gem 'thin'
gem 'rerun'
gem 'rb-fsevent' if HOST_OS =~ /darwin/
gem 'rake'

gem 'redis'
gem 'redis-namespace'
gem 'mecab'

gem 'haml'
gem 'activesupport', '~> 3.2'

group :test, :development do
  gem 'wirble'
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'debugger'
  gem 'capybara'
  gem 'launchy'
  gem 'cucumber'
  gem 'cucumber-sinatra'
  gem 'rspec'
end
