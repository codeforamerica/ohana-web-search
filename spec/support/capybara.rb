require 'capybara/rails'

Capybara.configure do |config|
  config.javascript_driver = :webkit
  config.default_wait_time = 30
end

Capybara.add_selector(:rel) do
  xpath { |rel| ".//a[@rel='#{rel}']" }
end
