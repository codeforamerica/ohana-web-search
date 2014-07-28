HumanServicesFinder::Application.configure do
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
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  # config.cache_store = :dalli_store

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

  # If the app is not using active_record/railtie (see application.rb),
  # the setting below should be disabled.
  #
  # Raise an error on page load if there are pending migrations.
  # config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # For use with the sprockets_better_errors gem.
  # Remove this and the gem after upgrading to Rails 4.1+.
  config.assets.raise_production_errors = true
end
