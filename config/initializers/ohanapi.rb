cache = Readthis::Cache.new(
  expires_in: ENV.fetch('RRC_EXPIRES_IN', 300).to_i,
  namespace: 'faraday',
  redis: { url: ENV.fetch('REDISCLOUD_URL', 'redis://localhost:6379'), driver: :hiredis }
)

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, store: cache, serializer: Marshal
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Ohanakapa.configure do |config|
  config.api_token = ENV.fetch('OHANA_API_TOKEN', nil)
  config.api_endpoint = ENV.fetch('OHANA_API_ENDPOINT', nil)

  config.middleware = stack unless Rails.env.test?
end
