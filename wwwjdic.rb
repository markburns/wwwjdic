require './lib/setup'

class Wwwjdic < Sinatra::Application
  get "/" do
    word_search
  end

  get "/word-search/:query" do
    word_search
  end

  def word_search
    @query = params['query']
    return haml :word_search if @query.blank?


    @edict_entries = Search.perform @query
    @show_extended = true

    respond_to do |wants|
      wants.json  { @edict_entries.to_json }
      wants.html  { haml :search_results }
    end
  end

  get "/:query" do
    word_search
  end

  get "/word-search" do
    word_search
  end

  get '/auto-complete' do
    headers 'Content-Type' => "content-type:text/javascript;charset=utf-8"

    results = AutoComplete.find params['auto_complete']
    results.to_json
  end
end
