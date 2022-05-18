module Cacheable
  def cache_page(field)
    return unless ENV.fetch('ENABLE_CACHING', nil) == 'true'

    fresh_when(
      etag: latest_commit_hash, last_modified: field, public: true
    )
  end

  def latest_commit_hash
    ENV.fetch('LATEST_COMMIT_HASH', nil)
  end
end
