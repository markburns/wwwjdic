require 'sinatra'
require 'sinatra/base'
require 'ruby-debug'
require 'haml'
require 'json'
require 'active_support/core_ext/hash'


require './app/data_access/redis_helpers'
require './app/data_access/auto_complete'
require './app/data_access/page'
require './app/data_access/tokenizer'


require './app/helpers/legacy_app'
require './app/helpers/helpers'

require './app/models/search'
require './app/models/edict_entry'
require './lib/edict_constants'

load './lib/tasks/redis.rake'
load './lib/tasks/dictionary.rake'

Rake::Task['redis:start'].invoke

class Wwwjdic < Sinatra::Application
  include EdictConstants
  set :haml, :format => :html5

  CHARACTER_ENCODING = 'utf-8'
  #set :haml, :encoding => CHARACTER_ENCODING
  #Encoding.default_internal = nil

  enable :logging, :static
  set :root, File.expand_path("../../app", __FILE__)
  set :public_dir, 'public'
end
