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

# To debug failures of javascript-enabled tests, you can add ":debug => true"
# as an additional option on line 20. For example:
# Capybara::Poltergeist::Driver.new(app, :js_errors => true, :debug => true)
# This will result in verbose output in the Terminal when running tests.

# You can also use Poltergeist's experimental remote debugging feature by
# replacing line 19-21 with:
# Capybara.register_driver :poltergeist_debug do |app|
#  Capybara::Poltergeist::Driver.new(app, :inspector => true)
# end
# You will also need to add Capybara.javascript_driver = :poltergeist_debug
# on line 45. Add "page.driver.debug" at a spot where you want to pause a test.
# When you run the test, it will pause at that spot, and will launch a browser
# window where you can inspect the page contents.
# Remember to remove "page.driver.debug" when you're done debugging!
# https://github.com/jonleighton/poltergeist#remote-debugging-experimental

# Sometimes, debugging is as simple as using Ruby's "puts" to output whatever
# you want to the Terminal. For example, if you want to see the URLs for
# all the visible links on the page at any point during a test, you can add
# this line: all('a').each { |a| puts a[:href] }

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
