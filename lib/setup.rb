require './lib/all_requires'

class Wwwjdic < Sinatra::Application
  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  include EdictConstants
  set :haml, :format => :html5

  CHARACTER_ENCODING = 'utf-8'

  enable :logging, :static
  set :root, File.expand_path("../../app", __FILE__)
  set :public_dir, 'public'

  require 'rack/conneg'

  use(Rack::Conneg) { |conneg|
    conneg.set :accept_all_extensions, true
    conneg.set :fallback, :html
    conneg.ignore('/stylesheets/')
    conneg.ignore_contents_of File.expand_path('../../public', __FILE__)
    conneg.provide([:json, :html])
  }

  before do
    if negotiated?
      content_type negotiated_type
    end
  end

end
