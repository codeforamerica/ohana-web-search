stack = Faraday::Builder.new do |builder|
  builder.use Faraday::HttpCache
  builder.use Ohanakapa::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Ohanakapa.configure do |config|
  config.api_token = ENV["OHANA_API_TOKEN"] unless Rails.env.test?

  if Rails.env.test?
    config.api_endpoint = "http://ohana-api-test.herokuapp.com/api"
  elsif ENV["OHANA_API_ENDPOINT"].blank?
    raise "The OHANA_API_ENDPOINT environment variable is not set! "+
      "To set it locally, add it to config/application.yml."
  else
    config.api_endpoint = ENV["OHANA_API_ENDPOINT"]
  end

  config.middleware = stack
end