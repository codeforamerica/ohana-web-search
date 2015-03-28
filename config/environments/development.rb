Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true

  # Uncomment lines 22-28 below to test HTTP caching in development.
  # Visit the Wiki for more details:
  # https://github.com/codeforamerica/ohana-web-search/wiki/Improving-performance-with-caching
  #
  # config.action_controller.perform_caching = true
  # config.cache_store = :dalli_store
  # client = Dalli::Client.new
  # config.action_dispatch.rack_cache = {
  #   metastore: client,
  #   entitystore: client
  # }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # ## ActionMailer Config
  # config.action_mailer.default_url_options = { :host => 'localhost:8080' }
  # config.action_mailer.delivery_method = :smtp

  # ## change to true to allow email to be sent during development
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.default :charset => "utf-8"

  #  config.action_mailer.smtp_settings = {
  #   :port =>           '587',
  #   :address =>        'smtp.mandrillapp.com',
  #   :user_name =>      ENV['MANDRILL_USERNAME'],
  #   :password =>       ENV['MANDRILL_APIKEY'],
  #   :domain =>         'heroku.com',
  #   :authentication => :plain
  #  }
  config.action_mailer.delivery_method = :letter_opener # use gem for mocking mail

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  # config.assets.digest = true

  # Uncomment this if you want to precompile assets locally.
  # http://guides.rubyonrails.org/asset_pipeline.html#local-precompilation
  # config.assets.prefix = '/dev-assets'

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true
end
