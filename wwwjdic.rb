require 'sinatra'
require 'sinatra/base'
require 'ruby-debug'
require 'haml'
require 'json'
require './legacy_app'
require './helpers'
require './lib/auto_complete'
require './lib/search'
require './lib/page'
require './lib/tokenizer'
require './lib/edict_entry'
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
  set :root, File.dirname(__FILE__)
  set :public_dir, 'public'

  get "/" do
    redirect "/word-search"
  end

  get "/word-search" do
    @query = params['query']
    return haml :word_search if @query.blank?


    @edict_entries = Search.perform @query

    @show_extended = true
    return haml :search_results

  end

  get '/auto-complete' do
    headers 'Content-Type' => "content-type:text/javascript;charset=utf-8"

    results = AutoComplete.find params['auto_complete']
    results.to_json
  end
end
