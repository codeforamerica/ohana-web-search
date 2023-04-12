source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'actionmailer', '~> 6.1'
gem 'compass-rails'
gem 'dalli', '~> 3.2.3'
gem 'faraday', '~> 0.8'
gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'font-awesome-rails'
gem 'google-api-client', '~> 0.9'
gem 'haml-rails'
gem 'kaminari-actionview', '= 1.1.1'
gem 'kaminari-core', '= 1.1.1'
gem 'kgio'
gem 'memcachier'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma', '~> 5.6.4'
gem 'rack-cache', '~> 1.2'
gem 'rack-rewrite', '~> 1.5.0'
gem 'railties', '~> 6.1'
gem 'sass-rails', '~> 5.0.1'
gem 'sprockets', '~> 3.7.1'
gem 'uglifier'
gem 'webpacker', '~> 5.2'

# dev and debugging tools
group :development do
  gem 'better_errors'
  gem 'bummr'
  gem 'derailed'
  gem 'flamegraph'
  gem 'letter_opener'
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
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter', require: false
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'simplecov', '= 0.17.1', require: false
  gem 'vcr'
  gem 'webdrivers', '>= 4.1.2'
  gem 'webmock'
end

group :development, :test do
  gem 'rspec-rails', '~> 5.1'
end
