cache_store =
  if Rails.env.test?
    Rails.cache
  else
    ActiveSupport::Cache.lookup_store(:dalli_store)
  end

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, store: cache_store, serializer: Marshal
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Ohanakapa.configure do |config|
  config.api_token = ENV.fetch('OHANA_API_TOKEN', nil) if ENV['OHANA_API_TOKEN'].present?
  config.api_endpoint = ENV.fetch('OHANA_API_ENDPOINT', nil)

  config.middleware = stack
end
