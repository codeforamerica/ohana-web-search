require_relative 'boot'

# Pick the frameworks you want:
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

SETTINGS = YAML.safe_load(File.read(File.expand_path('settings.yml', __dir__)))
SETTINGS.merge! SETTINGS.fetch(Rails.env, {})
SETTINGS.symbolize_keys!

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OhanaWebSearch
  class Application < Rails::Application
    config.load_defaults 6.0
    # Don't generate RSpec tests for views and helpers.
    config.generators do |generator|
      generator.test_framework :rspec
      generator.view_specs false
      generator.helper_specs false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
