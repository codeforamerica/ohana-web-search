source 'https://rubygems.org'

ruby '2.1.1'
gem 'rails', '3.2.17'

# front end
group :assets do
  gem 'html5shiv-rails' # needed for IE polyfill of sectioning content
  gem 'selectivizr-rails' # needed for IE polyfill of modern CSS selectors
  gem 'sass-rails', '>= 3.2.6'
  gem 'font-awesome-sass', '>= 4.0.3.1' #font-awesome icons
  gem 'compass-rails', '>= 1.1.7'
  gem 'uglifier', '>= 2.5.0'
end

gem 'requirejs-rails', '0.9.1'
gem 'haml-rails'

# server
gem "unicorn", ">= 4.3.1"
gem 'newrelic_rpm'
gem "ohanakapa", "~> 1.0"
gem 'faraday-http-cache'

# Caching
gem "rack-cache"
gem "dalli"
gem "memcachier"
gem "kgio"

# URL redirects
gem "rack-rewrite"

## For passing data to JS
## http://railscasts.com/episodes/324-passing-data-to-javascript
#gem "gon"


# For Google translation API
gem "google-api-client"

# app config and ENV variables for heroku
gem "figaro", ">= 0.6.3"

gem 'coveralls', require: false

group :production, :staging do
  # rails_12factor runs only in production to suppress logging in rspec output.
  # Per advice of http://stackoverflow.com/questions/18132920/how-to-suppress-noise-from-requests-when-running-rspec-feature-specs
  gem 'rails_12factor' # Heroku recommended
end

# dev and debugging tools
group :development do
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
  gem "metric_fu"
  gem "letter_opener" # for mocking emails for sending
  gem 'jshintrb' # for linting JS with `rake jshint`
end

group :test do
  #gem "cucumber-rails", ">= 1.3.1", :require => false
  #gem "launchy", ">= 2.2.0"
  gem "capybara"
  gem 'json'
  gem 'rack_session_access' # for getting access to the session from Capybara
  gem 'poltergeist'
  #gem 'selenium-webdriver'
  #gem 'capybara-webkit'
  gem "vcr"
  gem 'webmock', "< 1.16.0"
  gem "email_spec"
end

group :development, :test do
  #gem "teaspoon" #enable teaspoon to use JasmineJS for performing unit testing on JS code
  gem "rspec-rails", ">= 2.14"
  gem 'yard' #for code documentation
end