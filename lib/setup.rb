require './lib/all_requires'

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
