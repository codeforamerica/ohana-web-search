require 'webdrivers/chromedriver'

Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.always_include_port = true
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu] }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end
Capybara.javascript_driver = :headless_chrome

Capybara.add_selector(:rel) do
  xpath { |rel| ".//a[@rel='#{rel}']" }
end

Webdrivers.cache_time = 86_400
