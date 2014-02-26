HumanServicesFinder::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.middleware.use '::Rack::Auth::Basic' do |u, p|
    [u, p] == [ENV["STAGING_USER"], ENV["STAGING_PASSWORD"]]
  end

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Add the fonts path
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

  # Precompile additional assets
  config.assets.precompile << %w( *.svg *.eot *.woff *.ttf ) # fonts
  config.assets.precompile << %w( html5shiv.js html5shiv-printshiv.js ) #polyfill

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  #config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store
  client = Dalli::Client.new(ENV["MEMCACHIER_SERVERS"],
                              :value_max_bytes => 10485760)
  config.action_dispatch.rack_cache = {
    :metastore    => client,
    :entitystore  => client
  }
  config.static_cache_control = "public, max-age=2592000"

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #config.assets.precompile << "*.js"

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  #config.action_mailer.default_url_options = { :host => 'example.com' }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.default_url_options = { :host => 'ohana.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
    :port =>           '587',
    :address =>        'smtp.mandrillapp.com',
    :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'heroku.com',
    :authentication => :plain
  }

end
