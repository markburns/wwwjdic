require 'sinatra'
require 'sinatra/base'
require 'ruby-debug'
require 'haml'
require 'json'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object'

require 'redis'
require 'redis-namespace'
require './app/data_access/redis_helpers'
require './app/data_access/auto_complete'
require './app/data_access/page'


require './app/helpers/legacy_app'
require './app/helpers/helpers'

require './app/models/tokenizer'
require './app/models/search'
require './app/models/edict_entry'
require './lib/edict_constants'

load './lib/tasks/redis.rake'
load './lib/tasks/dictionary.rake'


