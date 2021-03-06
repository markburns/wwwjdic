require 'sinatra'
require 'sinatra/base'
require 'ruby-debug'
require 'pry'
require "better_errors"
require 'haml'
require 'json'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/object'

require 'mecab'
require 'redis'
require 'redis-namespace'
require './app/data_access/redis_helpers'
require './app/data_access/auto_complete'
require './app/data_access/page'


require './lib/legacy_app'
require './app/helpers/linkable_word'
require './app/helpers/haml_helpers'

require './app/models/tokenizer'
require './app/models/search'
require './app/models/edict_entry'
require './app/models/mecab_result'
require './lib/edict_constants'
require './db/edict_parser'
require './db/edict_indexes'
require './db/dictionaries'

require 'rake'
load './lib/tasks/dictionary.rake'
