Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Thanks to the "rack-rewrite" gem, the code in lines 38-53 will redirect all
  # URLs that don't come from the domain specified in the canonica_url variable
  # to the canonical URL equivalent. Full URLs are preserved
  # (i.e. including path and parameters).
  #
  # This is necessary if search engines have been indexing your site while it
  # was hosted on herokuapp.com, and you later set up a custom domain name.
  # Adding a custom domain on Heroku does not automatically redirect the heroku
  # domain to your custom domain, which leaves your site accessible via two
  # different domain names, which major search engines consider duplicate
  # content and can count against you.
  # By setting up this permanent redirect (via the HTTP 301 status code),
  # you tell search engines that the canonical URL is the one you prefer, and
  # it prevents them from continuing to index the duplicate content.
  #
  # Google's recommendations for canonicalization:
  # https://support.google.com/webmasters/answer/139066
  #
  # When deploying, set the environment variable to your desired URL.
  # For example, if you want the URL to be "smc-connect.org" and you
  # are deploying to Heroku, you would use the command line to run this from
  # your app's directory: heroku config:set CANONICAL_URL=smc-connect.org
  #
  # To test the redirection in development, you can set the environment
  # variable in config/application.yml by adding this line:
  # CANONICAL_URL: smc-connect.org (or whatever URL you want).
  # Alternatively, you can export the environment variable
  # locally by running this command from the directory of your app:
  # export CANONICAL_URL=smc-connect.org
  #
  # Then copy and paste lines 38-53 from this file into
  # config/environments/development.rb and restart your server.
  # Don't forget to remove the redirection code from development.rb
  # when you're done testing.
  config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    if ENV['CANONICAL_URL'].blank?
      raise 'The CANONICAL_URL environment variable is not set on your' \
      ' production server. It should be set to your app\'s domain name,' \
      ' without the protocol. For example: www.smc-connect.org, or' \
      ' flying-tiger.herokuapp.com. If you\'re using Heroku, you can set it' \
      ' like this: "heroku config:set CANONICAL_URL=your_domain_name". See' \
      ' config/environments/production.rb in the source code for more details.'
    else
      canonical_url = ENV['CANONICAL_URL']

      r301(%r{/organizations(.*)}, '/locations$1')
      r301(/.*/, "http://#{canonical_url}$&",
           if: proc { |rack_env| rack_env['SERVER_NAME'] != canonical_url })
    end
  end

  # --------------------------------------------------------------------------
  # CACHING SETUP FOR RACK:CACHE AND MEMCACHIER ON HEROKU
  # https://devcenter.heroku.com/articles/rack-cache-memcached-rails31
  # ------------------------------------------------------------------

  config.serve_static_files = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  config.action_controller.perform_caching = true

  config.cache_store = :dalli_store
  client = Dalli::Client.new((ENV['MEMCACHIER_SERVERS'] || '').split(','),
                             username: ENV['MEMCACHIER_USERNAME'],
                             password: ENV['MEMCACHIER_PASSWORD'],
                             failover: true,
                             socket_timeout: 1.5,
                             socket_failure_delay: 0.2,
                             value_max_bytes: 10_485_760)
  config.action_dispatch.rack_cache = {
    metastore:   client,
    entitystore: client
  }
  config.static_cache_control = 'public, max-age=2592000'
  # --------------------------------------------------------------------------

  # --------------------------------------------------------------------------
  # EMAIL DELIVERY SETUP WITH SENDGRID ON HEROKU
  # https://devcenter.heroku.com/articles/sendgrid
  # ----------------------------------------------

  config.action_mailer.default_url_options = { host: ENV['CANONICAL_URL'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true

  # Ignore bad email addresses and do not raise email delivery errors.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    port:           '587',
    address:        'smtp.sendgrid.net',
    user_name:      ENV['SENDGRID_USERNAME'],
    password:       ENV['SENDGRID_PASSWORD'],
    domain:         'heroku.com',
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
  config.force_ssl = (ENV['ENABLE_HTTPS'] == 'yes')

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
end
