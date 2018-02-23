source 'https://rubygems.org'

ruby '2.3.3'
gem 'actionmailer', '~> 4.2.9'
gem 'compass-rails'
gem 'dalli', '~> 2.7.1'
gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'font-awesome-rails'
gem 'google-api-client', '~> 0.9'
gem 'haml-rails'
gem 'kaminari-actionview'
gem 'kaminari-core'
gem 'kgio'
gem 'memcachier'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma'
gem 'rack-cache', '~> 1.2'
gem 'rack-rewrite', '~> 1.5.0'
gem 'railties', '~> 4.2'
gem 'sass-rails', '~> 5.0.1'
gem 'sprockets', '~> 2.12'
gem 'uglifier'
gem 'webpacker', '~> 3.2'

group :production, :staging do
  # Enables serving assets in production and setting logger to standard out.
  gem 'rails_12factor'
end

# dev and debugging tools
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', '~> 0.7.2', platforms: %i[mri_19 rbx]
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
  gem 'capybara', '~> 2.4'
  gem 'coveralls', require: false
  gem 'email_spec'
  gem 'haml_lint'
  gem 'poltergeist'
  gem 'rubocop'
  gem 'vcr'
  gem 'webmock', '~> 2.1'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
end
