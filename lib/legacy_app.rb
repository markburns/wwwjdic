module LegacyApp
  extend self

  MAPPINGS_FOR_GET_REQUESTS =
    { 
    'word-search'         => "1C", 
    'text_glossing'       => "9T",
    'kanji_lookup'        => "1B", 
    'multi_radical_kanji' => "1R",
    'text_glossing'       => "9T", 
    'customization'       => "19B",
    'example_search'      => "10"
  }

  MAPPINGS_FOR_POST_REQUESTS =
    { 'word-search'         => "1E",
      'text_glossing'       => "9T",
      'kanji_lookup'        => "1B",
      'multi_radical_kanji' => "1R",
      'text_glossing'       => "9T",
      'customization'       => "19B",
      'example_search'      => "10"
  }

  def lookup_get_action params
    action_from MAPPINGS_FOR_GET_REQUESTS
  end

  def lookup_post_action params
    action_from MAPPINGS_FOR_POST_REQUESTS
  end

  def action_from mapping
    action, _ = mapping.find{|k,v|  params.include?(v) ? k.to_s : false}
    action || 'word-search'
  end

  def word_search_params_mapping
    { 'search'            => :dsrchkey,
      'dictionary'        => :dicsel,
      'romaji'            => :dsrchtype,
      'common_words'      => :engpri,
      'exact_match'       => :exactm,
      'match_first_kanji' => :firstkanj
    }
  end

  def convert_params params
    output = {}

    word_search_params_mapping.each do |output_param, input_param|
      output[output_param] = params[input_param]
    end

    output
  end
end

get "/wwwjdic.cgi" do
  action = LegacyApp.lookup_get_action params

  call env.merge('PATH_INFO'=>action)
end

post '/wwwjdic.cgi' do
  action = LegacyApp.lookup_post_action request.path_info
  converted_params = LegacyApp.convert_params action, params

  env["rack.request.form_hash"]  = converted_params
  env["rack.request.query_hash"] = converted_params
  env["rack.request.form_vars"]  = converted_params

  call env.merge("PATH_INFO" => action)
end


