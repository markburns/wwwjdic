class LinkableWord
  def initialize query, text, word_class=''
    @query, @text, @word_class = query, text, word_class
  end

  def html
    word_class= " class='#{@word_class}'" if @word_class.present?
    @query_without_quotes ||=  @query.gsub(/"/,"")
    link_full_text = @query_without_quotes == @text

    if link_full_text
      "<a class='highlight' href='/word-search?query=#{@query}'>#{@text}</a>"

    elsif @text =~ /(^|\b)#{@query}\b/
      before, after = @text.split(/(^|\b)#{@query}/)
      link = "<span#{word_class}>#{before.try :strip}"
      encoded = URI.encode @query.strip
      link << "<a class='highlight' href='/word-search?query=#{encoded}'>#{@query_without_quotes}</a>"
      link << "#{after.try :strip}</span>"
    else
      unquoted = @text.gsub(/"/,'')
      "<a href='/word-search?query=#{URI.encode @text}'><span#{word_class}>#{unquoted}</span></a>"
    end
  end
end
