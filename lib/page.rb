class Page < Array
  def self.paginate items, page, page_size=25
    new(items, page_size).page(page)
  end

  attr_reader :page_size

  def initialize items, page_size=25
    super items if items
    @page_size = page_size
  end

  def page p
    self[index_range_of(p)]
  end

  private

  def index_range_of page=1
    page_index = page - 1

    first = page_index * page_size
    last  = first      + page_size - 1
    first..last
  end
end
