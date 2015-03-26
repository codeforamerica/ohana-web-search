module Cacheable
  def cache_page(field)
    return unless ENV['ENABLE_CACHING'] == 'true'
    fresh_when(
      etag: ENV['LATEST_COMMIT_HASH'], last_modified: field, public: true)
  end
end
