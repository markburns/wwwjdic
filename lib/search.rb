
class Search
  include RedisHelpers
  extend RedisHelpers

  def initialize query, *criteria
    @query = query
    @criteria = criteria.empty? ? SORTED_ATTRIBUTES : criteria
  end

  attr_reader :query

  def results
    @results ||= search
  end

  FULL_TEXT_LOOKUP_FIELDS = [:english_definitions,:english_words]
  SORTED_ATTRIBUTES = [ :kanji, :kana ]  + FULL_TEXT_LOOKUP_FIELDS

  PAGE_SIZE=25

  private

  def multiple_token_search?
    @query =~ /\s/
  end

  def perform_lookup type, query
    search = "#{type}:#{query}"
    return if complete? || @searched[search]

    @ids = @ids + redis.smembers(search)

    @searched[search] = true
  end

  def complete?
    @ids.length >= @page_size
  end

  def search page=1, page_size= PAGE_SIZE
    @ids = []
    @page_size = page_size
    @searched = {}

    if multiple_token_search?
      (@criteria & FULL_TEXT_LOOKUP_FIELDS).map do |type|
        perform_lookup(type, query)
      end
    end

    tokens.each do |token|
      @criteria.map do |type|
        perform_lookup(type, token)
      end

      break if complete? 
    end

    @ids.map do |id|
      EdictEntry.new redis.hgetall "entry:#{id}"
    end
  end

  def tokens
    @tokens ||= Tokenizer.new(@query).tokens
  end

  def self.perform query
    new(query).results
  end

  def self.find type, key, page=1
    ids = redis.smembers "#{type}:#{key}"
    pages = Page.paginate(ids, page)
    return nil if pages.empty?

    pages.map do |id|
      EdictEntry.new redis.hgetall "entry:#{id}"
    end
  end
end
