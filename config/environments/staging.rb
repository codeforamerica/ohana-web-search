require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # This will password-protect your staging site so that search engines can't
  # index it. If they were to index it, they would penalize your site for
  # having duplicate content across two different sites.
  # The username and password are stored in environment variables that you
  # should set on your staging server. If you're deploying on Heroku, read this
  # article to learn how to set environment (also called config) variables:
  # https://devcenter.heroku.com/articles/config-vars
  config.middleware.use ::Rack::Auth::Basic do |u, p|
    [u, p] == [ENV.fetch('STAGING_USER', nil), ENV.fetch('STAGING_PASSWORD', nil)]
  end

  # --------------------------------------------------------------------------
  # CACHING SETUP FOR RACK:CACHE AND MEMCACHIER ON HEROKU
  # https://devcenter.heroku.com/articles/rack-cache-memcached-rails31
  # ------------------------------------------------------------------

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, s-maxage=2592000, maxage=86400'
  }

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  config.action_controller.perform_caching = true

  config.cache_store = :readthis_store, {
    expires_in: 2.weeks.to_i,
    namespace: 'cache',
    redis: { url: ENV.fetch('REDISCLOUD_URL'), driver: :hiredis }
  }

  config.action_dispatch.rack_cache = {
    metastore: "#{ENV.fetch('REDISCLOUD_URL')}/0/metastore",
    entitystore: "#{ENV.fetch('REDISCLOUD_URL')}/0/entitystore",
    use_native_ttl: true
  }
  # --------------------------------------------------------------------------

  # --------------------------------------------------------------------------
  # EMAIL DELIVERY SETUP WITH SENDGRID ON HEROKU
  # https://devcenter.heroku.com/articles/sendgrid
  # ----------------------------------------------

  config.action_mailer.default_url_options = { host: ENV.fetch('CANONICAL_URL', nil) }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true

  # Ignore bad email addresses and do not raise email delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    port: '587',
    address: 'smtp.sendgrid.net',
    user_name: 'apikey',
    password: ENV.fetch('SENDGRID_API_KEY', nil),
    domain: 'heroku.com',
    authentication: :plain,
    enable_starttls_auto: true
  }
  # ---------------------------------------------------------------------------

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor  = :uglifier
  # NOTE: If the sass-rails gem is included it will automatically
  # be used for CSS compression if no css_compressor is specified.
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.version` and `config.assets.precompile` have moved to
  # config/initializers/assets.rb

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Log disallowed deprecations.
  config.active_support.disallowed_deprecation = :log

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
  logger = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)
end
