module Cacheable
  def cache_page(field)
    return unless ENV['ENABLE_CACHING'] == 'true'

    fresh_when(
      etag: ENV['HEROKU_SLUG_COMMIT'], last_modified: field, public: true
    )
  end
end
