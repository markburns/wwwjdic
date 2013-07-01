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
      JapanesePod.new(entry).html
    end

    def linkable_word text, word_class=''
      LinkableWord.new(@query, text, word_class).html
    end
  end
end
