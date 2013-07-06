require './lib/setup'

class Wwwjdic < Sinatra::Application
  word_search = lambda do
    if query.present?
      lookup
    else
      return haml :word_search
    end

    respond_to do |wants|
      wants.json  { @edict_entries.to_json }
      wants.html  { haml :search_results }
    end
  end


  get "/word-search/:query", &word_search
  get "/word-search",        &word_search
  get "/",                   &word_search

  get '/auto-complete' do
    headers 'Content-Type' => "content-type:text/javascript;charset=utf-8"

    results = AutoComplete.find params['auto_complete']
    results.to_json
  end

  parse_sentence = lambda do
    @results = MeCabResult.new params[:sentence]

    haml :sentence
  end

  get %r{/parse_sentence/?} do
    @results = []
    haml :sentence
  end

  post "/parse_sentence", &parse_sentence
  get "/parse_sentence/:sentence", &parse_sentence

  def query
    @query ||= params['query']
  end

  def lookup
    @edict_entries = Search.perform query
    @show_extended = true
  end
end
