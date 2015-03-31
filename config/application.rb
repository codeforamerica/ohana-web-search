require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

SETTINGS = YAML.load(File.read(File.expand_path('../settings.yml', __FILE__)))
SETTINGS.merge! SETTINGS.fetch(Rails.env, {})
SETTINGS.symbolize_keys!

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OhanaWebSearch
  class Application < Rails::Application
    # Don't generate RSpec tests for views and helpers.
    config.generators do |g|
      g.test_framework :rspec
      g.view_specs false
      g.helper_specs false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Tell Internet Explorer to use compatibility mode.
    # 'edge' mode tells Internet Explorer to display content in the highest mode available.
    # 'chrome' mode is for when Internet Explorer has the Google Chrome Frame plug-in installed.
    # Note that Google Chrome Frame was retired in Jan. 2014, so this is only for legacy systems.
    # More info at http://blog.chromium.org/2013/06/retiring-chrome-frame.html
    config.action_dispatch.default_headers = { 'X-UA-Compatible' => 'IE=edge,chrome=1' }

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true
  end
end
