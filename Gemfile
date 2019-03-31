source 'https://rubygems.org'

ruby '2.5.3'
gem 'actionmailer', '~> 5.2'
gem 'compass-rails'
gem 'faraday-http-cache', '~> 2.0'
gem 'figaro'
gem 'font-awesome-rails'
gem 'google-api-client', '~> 0.9'
gem 'haml-rails'
gem 'kaminari-actionview'
gem 'kaminari-core'
gem 'ohanakapa', '~> 1.1.1'
gem 'puma'
gem 'rack-rewrite', '~> 1.5.0'
gem 'railties', '~> 5.2'
gem 'redis-rack-cache', git: 'https://github.com/monfresh/redis-rack-cache.git', branch: 'readthis-compatibility'
gem 'sass-rails', '~> 5.0.1'
gem 'skylight'
gem 'sprockets', '~> 3.7.1'
gem 'uglifier'
gem 'webpacker', '~> 3.2'

# dev and debugging tools
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: %i[mri_19 rbx]
  gem 'bummr'
  gem 'derailed'
  gem 'flamegraph'
  gem 'letter_opener'
  gem 'rack-mini-profiler', require: false
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
  gem 'rails-controller-testing'
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock', '~> 3.4'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
end
