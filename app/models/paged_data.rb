class PagedData
  attr_accessor :data, :total_pages, :current_page, :limit_value
  def initialize(data, total_pages, current_page, limit_value)
    self.data = data
    self.total_pages = total_pages
    self.current_page = current_page
    self.limit_value = limit_value
  end
  delegate :each, to: :data
end