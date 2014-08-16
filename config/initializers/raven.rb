require 'raven'

Raven.configure do |config|
  if Rails.env.production? && ENV['SENTRY_DSN'].blank?
    fail 'missing SENTRY_DSN environment variable'
  elsif Rails.env.production?
    config.dsn = ENV['SENTRY_DSN']
  end
end
