source 'https://rubygems.org'

ruby '2.1.1'
gem 'rails', '~> 4.0.4'

# FRONT END

# Use SCSS for stylesheets.
gem 'sass-rails', '~> 4.0.2'

# Compass tools for use with SCSS.
gem 'compass-rails', '>= 1.1.7'

# Font-awesome icons.
gem 'font-awesome-sass', '>= 4.0.3.1'

# Use Uglifier as compressor for JavaScript assets.
gem 'uglifier', '>= 2.5.0'

# For enabling requirejs-style AMD scripts in the asset pipeline.
gem 'requirejs-rails', '>= 0.9.2'

# For HAML HTML view templates.
gem 'haml-rails', '>= 0.5.3'

# SERVER

gem 'unicorn', '>= 4.8.3'
gem 'newrelic_rpm', '>= 3.8.0.218'
gem 'ohanakapa', '~> 1.1.1'
gem 'faraday-http-cache', '>= 0.4.0'

# Caching
gem 'rack-cache', '>= 1.2'
gem 'dalli', '~> 2.7.1'
gem 'memcachier'

# Required for caching in production.
gem 'kgio'

# URL redirects.
gem 'rack-rewrite', '>= 1.5.0'

# For Google translation API.
gem 'google-api-client', '>= 0.7.1'

# App config and ENV variables for heroku.
gem 'figaro', '>= 0.7.0'

gem 'coveralls', '>= 0.7.0', require: false

group :production, :staging do
  # rails_12factor runs only in production to suppress logging in rspec output.
  # Per advice of http://stackoverflow.com/questions/18132920/how-to-suppress-noise-from-requests-when-running-rspec-feature-specs
  # Heroku recommended.
  gem 'rails_12factor'
end

# dev and debugging tools
group :development do
  # Adds better errors to sprockets asset pipeline in development environment.
  gem 'sprockets_better_errors'

  gem 'quiet_assets', '>= 1.0.2'
  gem 'better_errors', '>= 1.1.0'
  gem 'binding_of_caller', '>= 0.7.2', :platforms => [:mri_19, :rbx]
  gem 'metric_fu', '>= 4.11.0'

  # For mocking emails for sending.
  gem 'letter_opener', '>= 1.2.0'

  # For linting JS with `rake jshint`.
  gem 'jshintrb', '>= 0.2.4'

  # For code documentation, run `yard --help` for list of commands.
  gem 'yard'
end

group :test do
  #gem 'launchy', '>= 2.2.0'
  gem 'capybara', '>= 2.2.1'
  gem 'json', '>= 1.8.1'

  # For getting access to the session from Capybara.
  gem 'rack_session_access'

  # gem 'poltergeist'
  gem 'capybara-webkit'
  gem 'vcr', '>= 2.9.0'
  gem 'webmock', '>= 1.17.4'
  gem 'email_spec', '>= 1.5.0'
end

group :development, :test do
  #gem 'teaspoon' #enable teaspoon to use JasmineJS for performing unit testing on JS code
  gem 'rspec-rails', '>= 2.14.2'
end