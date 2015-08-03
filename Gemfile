source 'https://rubygems.org'

ruby '2.2.1'
gem 'railties', '~> 4.2'
gem 'actionmailer'

# FRONT END

# Use SCSS for stylesheets.
gem 'sass-rails', '~> 5.0.1'

# Compass tools for use with SCSS.
gem 'compass-rails', '~> 2.0.4'

# Font-awesome icons.
gem 'font-awesome-rails'

# Use Uglifier as compressor for JavaScript assets.
gem 'uglifier'

# For enabling requirejs-style AMD scripts in the asset pipeline.
gem 'requirejs-rails'

# For HAML HTML view templates.
gem 'haml-rails'

# SERVER
gem 'puma'
gem 'ohanakapa', '~> 1.1.1'
gem 'faraday-http-cache', '~> 1.0'

# Caching
gem 'rack-cache', '~> 1.2'
gem 'dalli', '~> 2.7.1'
gem 'memcachier'

# Required for caching in production.
gem 'kgio'

# URL redirects.
gem 'rack-rewrite', '~> 1.5.0'

# For Google translation API.
gem 'google-api-client', '~> 0.8.1'

# App config and ENV variables for heroku.
gem 'figaro'

# Handles logic behind Pagination UI component.
gem 'kaminari'

group :production, :staging do
  # Enables serving assets in production and setting logger to standard out.
  gem 'rails_12factor'
end

# dev and debugging tools
group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller', '~> 0.7.2', platforms: [:mri_19, :rbx]

  # For mocking emails for sending.
  gem 'letter_opener'

  # For linting JS with `rake jshint`.
  gem 'jshint'

  # For code documentation, run `yard --help` for list of commands.
  gem 'yard'

  gem 'spring'
  gem 'spring-commands-rspec'
  # Required by spring to turn on event-based file system listening.
  gem 'spring-watcher-listen'
end

group :test do
  gem 'coveralls', require: false
  gem 'capybara', '~> 2.4.1'
  gem 'poltergeist'
  gem 'vcr', '~> 2.9.0'
  gem 'webmock', '~> 1.20'
  gem 'email_spec', '~> 1.6.0'
  gem 'haml-lint'

  # Ruby static code analyzer, based on the community Ruby style guide.
  gem 'rubocop'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
end
