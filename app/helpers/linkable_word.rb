class LinkableWord
  def initialize query, text, word_class=''
    @query, @text, @word_class = query, text, word_class
  end

  def html
    if link_full_text?
      full_text_link
    elsif part_match
      wrap_query_with_highlighted_linkable_word
    else
      default_link
    end
  end

  private

  def word_class
    " class='#{@word_class}'" if @word_class.present?
  end

  def default_link
    "<a href='/word-search/#{URI.encode @text}'><span#{word_class}>#{unquoted}</span></a>"
  end

  def part_match
    @text =~ /(^|\b)#{@query}\b/
  end

  def uri_encoded_query
    URI.encode @query.strip
  end

  def wrap_query_with_highlighted_linkable_word
    span do
      "<a class='highlight' href='/word-search/#{uri_encoded_query}'>#{query_without_quotes}</a>"
    end
  end

  def span
    before, after = @text.split(/(^|\b)#{@query}/)
    html = "<span#{word_class}>#{before.try :strip}"
    html << yield
    html << "#{after.try :strip}</span>"
    html
  end

  def link_full_text?
    @link_full_text ||= query_without_quotes == @text
  end

  def unquoted
    @unquoted ||= @text.gsub(/"/,'')
  end

  def full_text_link
    "<a class='highlight' href='/word-search#{uri_encoded_query}'>#{@text}</a>"
  end

  def query_without_quotes
    @query_without_quotes ||=  @query.gsub(/"/,"")
  end
end
