require './lib/setup'

class Wwwjdic < Sinatra::Application
  word_search = lambda do
    @query = params['query']
    return haml :word_search if @query.blank?


    @edict_entries = Search.perform @query
    @show_extended = true

    respond_to do |wants|
      wants.json  { @edict_entries.to_json }
      wants.html  { haml :search_results }
    end
  end

  get "/"                   &word_search
  get "/:query"             &word_search
  get "/word-search"        &word_search
  get "/word-search/:query" &word_search

  get '/auto-complete' do
    headers 'Content-Type' => "content-type:text/javascript;charset=utf-8"

    results = AutoComplete.find params['auto_complete']
    results.to_json
  end
end
