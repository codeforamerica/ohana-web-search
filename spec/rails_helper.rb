ENV['RAILS_ENV'] ||= 'test'
ENV['TZ'] = 'America/Los_Angeles'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!('rails')

  SimpleCov.start do
    add_filter '.bundle'
    add_filter 'spec'
  end
end

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'email_spec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Helper methods for use with Capybara feature specs.
  config.include Features::SessionHelpers, type: :feature

  config.include DetailFormatHelper
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  # rspec-rails 3+ will no longer automatically infer an example group's spec
  # type from the file location. You can explicitly opt in to this feature by
  # uncommenting the setting below.
  config.infer_spec_type_from_file_location!
end
