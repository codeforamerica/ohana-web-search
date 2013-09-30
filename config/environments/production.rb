HumanServicesFinder::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Thanks to the "rack-rewrite" gem, the code in lines 38-43 will redirect all
  # URLs that don't come from the domain specified in the canonica_url variable
  # to the canonical URL equivalent. Full URLs are preserved
  # (i.e. including path and parameters).
  #
  # This is necessary if search engines have been indexing your site while it
  # was hosted on herokuapp.com, and you later set up a custom domain name.
  # Adding a custom domain on Heroku does not automatically redirect the heroku
  # domain to your custome domain, which leaves your site accessible via two
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
  # Then copy and paste lines 38-43 from this file into
  # config/environments/development.rb and restart your server.
  # Don't forget to remove the redirection code from development.rb
  # when you're done testing.
  config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    canonical_url = ENV["CANONICAL_URL"]

    r301 %r{.*}, "http://#{canonical_url}$&",
      :if => Proc.new { |rack_env| rack_env['SERVER_NAME'] != "#{canonical_url}" }
  end

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

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
