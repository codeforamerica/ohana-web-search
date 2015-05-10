require 'capybara/poltergeist'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.default_wait_time = 30
  config.always_include_port = true
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_options: ['--ignore-ssl-errors=yes'])
end

Capybara.add_selector(:rel) do
  xpath { |rel| ".//a[@rel='#{rel}']" }
end
