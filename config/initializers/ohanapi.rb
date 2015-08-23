cache = Readthis::Cache.new(
  ENV.fetch('REDISCLOUD_URL', 'redis://localhost:6379'),
  driver: :hiredis,
  expires_in: ENV.fetch('RRC_EXPIRES_IN', 300).to_i,
  namespace: 'faraday')

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, store: cache, serializer: Marshal
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Ohanakapa.configure do |config|
  config.api_token = ENV['OHANA_API_TOKEN'] if ENV['OHANA_API_TOKEN'].present?
  config.api_endpoint = ENV['OHANA_API_ENDPOINT']

  config.middleware = stack unless Rails.env.test?
end
