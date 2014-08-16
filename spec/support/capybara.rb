require 'capybara/poltergeist'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.default_wait_time = 30
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
