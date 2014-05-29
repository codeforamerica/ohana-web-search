# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'coveralls'
Coveralls.wear!('rails')
# Don't put anything above this!

ENV["RAILS_ENV"] ||= 'test'
ENV['TZ'] = 'America/Los_Angeles'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'
require 'capybara/poltergeist'
require "rack_session_access/capybara"
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :js_errors => false)
end

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 30

RSpec.configure do |config|

  config.include Features::SessionHelpers, type: :feature
  config.include DetailFormatHelper
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.default_cassette_options = { :record => :once }
  c.cassette_library_dir  = "spec/cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("<GOOGLE_TRANSLATE>") do
    ENV['GOOGLE_TRANSLATE_API_TOKEN']
  end
end
