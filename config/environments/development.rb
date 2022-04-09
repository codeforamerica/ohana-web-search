require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  # config.webpacker.check_yarn_integrity = true

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  # Visit the Wiki for more details:
  # https://github.com/codeforamerica/ohana-web-search/wiki/Improving-performance-with-caching
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :mem_cache_store
    config.action_controller.enable_fragment_cache_logging = true
    client = Dalli::Client.new
    config.action_dispatch.rack_cache = {
      metastore: client,
      entitystore: client
    }
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # ## ActionMailer Config
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # config.action_mailer.default_url_options = { :host => 'localhost:8080' }
  # config.action_mailer.delivery_method = :smtp

  # ## change to true to allow email to be sent during development
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.default :charset => "utf-8"

  #  config.action_mailer.smtp_settings = {
  #   :port =>           '587',
  #   :address =>        'smtp.sendgrid.net',
  #   :user_name =>      ENV['SENDGRID_USERNAME'],
  #   :password =>       ENV['SENDGRID_APIKEY'],
  #   :domain =>         'heroku.com',
  #   :authentication => :plain
  #  }
  config.action_mailer.delivery_method = :letter_opener # use gem for mocking mail

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Uncomment this if you want to precompile assets locally.
  # http://guides.rubyonrails.org/asset_pipeline.html#local-precompilation
  # config.assets.prefix = '/dev-assets'
end
