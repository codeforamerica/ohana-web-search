source 'https://rubygems.org'

ruby '2.3.3'
gem 'actionmailer', '~> 4.2.9'
gem 'compass-rails'
gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'font-awesome-rails'
gem 'google-api-client', '~> 0.9'
gem 'haml-rails'
gem 'kaminari-actionview'
gem 'kaminari-core'
gem 'newrelic_rpm', '>= 3.8.0.218'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma'
gem 'rack-rewrite', '~> 1.5.0'
gem 'railties', '~> 4.2'
gem 'redis-rack-cache', git: 'https://github.com/monfresh/redis-rack-cache.git', branch: 'readthis-compatibility'
gem 'requirejs-rails', '= 0.9.5'
gem 'sass-rails', '~> 5.0.1'
gem 'sprockets', '~> 2.12'
gem 'uglifier'

group :production, :staging do
  # Enables serving assets in production and setting logger to standard out.
  gem 'rails_12factor'
end

# dev and debugging tools
group :development do
  gem 'better_errors'
  gem 'bummr'
  gem 'derailed'
  gem 'flamegraph'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'
  gem 'reek'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'stackprof'
  gem 'yard'
end

group :test do
  gem 'capybara'
  gem 'email_spec'
  gem 'haml_lint'
  gem 'poltergeist'
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock', '~> 2.1'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
end
