module Cacheable
  def cache_page(field)
    return unless ENV.fetch('ENABLE_CACHING', false) == 'true'

    fresh_when(
      etag: ENV.fetch('HEROKU_SLUG_COMMIT', nil), last_modified: field, public: true
    )
  end
end
