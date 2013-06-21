require './setup'

class Wwwjdic < Sinatra::Application
  get "/" do
    redirect "/word-search"
  end

  get "/word-search" do
    @query = params['query']
    return haml :word_search if @query.blank?


    @edict_entries = Search.perform @query

    @show_extended = true
    haml :search_results
  end

  get '/auto-complete' do
    headers 'Content-Type' => "content-type:text/javascript;charset=utf-8"

    results = AutoComplete.find params['auto_complete']
    results.to_json
  end
end
