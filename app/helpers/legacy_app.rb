class LegacyApp
  MAPPINGS_FOR_GET_REQUESTS =
    { 'word-search'    => "1C", :text_glossing => "9T",
      :kanji_lookup   => "1B", :multi_radical_kanji => "1R",
      :text_glossing  => "9T", :customization => "19B",
      :example_search => "10"}

  MAPPINGS_FOR_POST_REQUESTS =
    { :'word-search'  => "1E",
      :text_glossing  => "9T",
      :kanji_lookup   => "1B",
      :multi_radical_kanji => "1R",
      :text_glossing  => "9T",
      :customization => "19B",
      :example_search => "10"}

  def self.lookup_get_action params
    action = MAPPINGS_FOR_GET_REQUESTS.find{|k,v|  params.include?(v) ? k : false}
    return action.first.to_s if action
    action ||= 'word-search'
  end

  def self.lookup_post_action params
    action = MAPPINGS_FOR_POST_REQUESTS.find{|k,v|  params.include?(v) ? k : false}
    return action.first.to_s if action
    action ||= 'word-search'
  end


  def self.word_search_params_mapping
    { :search => :dsrchkey,
      :dictionary => :dicsel,
      :romaji => :dsrchtype,
      :common_words => :engpri,
      :exact_match => :exactm,
      :match_first_kanji => :firstkanj
    }
  end

  def self.convert_params path, params
    output = {}
    case path

    when "word-search"
      word_search_params_mapping.each do |output_param, input_param|
        val = params[input_param]
        params.delete input_param
        output[output_param] = val
      end
    end

    #put remaining attributes back in hash
    output
  end


end

get "/wwwjdic.cgi" do
  action = LegacyApp.lookup_get_action params
  call env.merge('PATH_INFO'=>action)
  puts env
end

post '/wwwjdic.cgi' do
  action = LegacyApp.lookup_post_action request.path_info
  converted_params = LegacyApp.convert_params action, params

  env["rack.request.form_hash"]  = converted_params
  env["rack.request.query_hash"] = converted_params
  env["rack.request.form_vars"]  = converted_params

  status, headers, body = call env.merge("PATH_INFO" => action)
end


