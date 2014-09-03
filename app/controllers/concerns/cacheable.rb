module Cacheable
  def cache_page(field)
    return unless ENV['ENABLE_CACHING'] == 'true'
    fresh_when last_modified: field, public: true
  end
end
