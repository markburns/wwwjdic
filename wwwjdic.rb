require './lib/setup'

class Wwwjdic < Sinatra::Application
  def tagger
    @tagger||= MeCab::Tagger.new
  end

  get "/parse_sentence/:sentence" do
    tagger.parse params[:sentence]
  end

  get '/auto-complete' do
    headers 'Content-Type' => "content-type:text/javascript;charset=utf-8"

    results = AutoComplete.find params['auto_complete']
    results.to_json
  end

  def query
    @query ||= params['query']
  end

  def lookup
    @edict_entries = Search.perform query
    @show_extended = true
  end

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
  get "/:query",             &word_search
  get "/",                   &word_search
end
