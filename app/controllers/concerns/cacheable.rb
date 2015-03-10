module Cacheable
  def cache_page(field)
    return unless ENV['ENABLE_CACHING'] == 'true'
    fresh_when(
      etag: latest_commit_hash, last_modified: field, public: true)
  end

  def latest_commit_hash
    ENV['LATEST_COMMIT_HASH']
  end
end
