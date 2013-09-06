stack = Faraday::Builder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Ohanakapa.configure do |config|
  config.api_token = ENV["OHANA_STAGING_API_TOKEN"]
  config.middleware = stack
end