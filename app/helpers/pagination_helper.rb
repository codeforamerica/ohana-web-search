module PaginationHelper
  def rel_attribute(page)
    return 'next' if page.next?
    return 'prev' if page.prev?
  end
end
