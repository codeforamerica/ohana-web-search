stack = Faraday::Builder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Ohanakapa.configure do |config|
  config.api_token = ENV['OHANA_API_TOKEN'] if ENV['OHANA_API_TOKEN'].present?
  config.api_endpoint = ENV['OHANA_API_ENDPOINT']

  config.middleware = stack
end