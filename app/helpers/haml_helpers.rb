module Haml
  module Helpers
    def partial(template, *args)
      template_array = template.to_s.split('/')
      template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"

      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:layout => false)

      if collection = options.delete(:collection)
        collection.inject([]) do |buffer, member|

          buffer << haml(:"#{template}",
                         options.merge(:layout => false,
                                       :locals => {template_array[-1].to_sym => member}))
        end.join("\n")
      else
        haml(:"#{template}", options)
      end
    end

    def japanese_pod_mp3 entry
      kana_encoded  = URI.encode "kana=#{URI.encode entry.kana.first }" if entry.kana.any?
      kanji_encoded = URI.encode "kanji=#{URI.encode entry.kanji}"      if entry.kanji.present?

      uri = if kana_encoded.present? && kanji_encoded.present?
              kana_encoded << "%26" << kanji_encoded
            elsif kana_encoded.present?
              kana_encoded
            elsif kanji_encoded.present?
              kanji_encoded
            end
      return unless uri

      haml_tag(:script, {:type => 'text/javascript' }) do
        haml_concat "m('#{uri}');"
      end
    end

    def linkable_word text, word_class=''
      word_class= " class='#{word_class}'" if word_class.present?
      @query_without_quotes ||=  @query.gsub(/"/,"")
      link_full_text = @query_without_quotes == text

      if link_full_text
        "<a class='highlight' href='/word-search?query=#{@query}'>#{text}</a>"

      elsif text =~ /(^|\b)#{@query}\b/
        before, after = text.split(/(^|\b)#{@query}/)
        link = "<span#{word_class}>#{before.try :strip}"
        link << "<a class='highlight' href='/word-search?query=#{@query.strip}'>#{@query_without_quotes}</a>"
        link << "#{after.try :strip}</span>"
      else
        unquoted = text.gsub(/"/,'')
        "<a href='/word-search?query=#{text}'><span#{word_class}>#{unquoted}</span></a>"
      end
    end
  end
end
