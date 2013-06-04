source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

# front end
#gem 'jquery-rails'
gem 'haml-rails'
#gem "bootstrap-sass", ">= 2.3.0.0"
gem "simple_form", ">= 2.1.0"

# server
gem "unicorn", ">= 4.3.1"
gem 'newrelic_rpm'

# app config and ENV variables for heroku
gem "figaro", ">= 0.6.3"

# MongoDB
gem "mongoid", ">= 3.1.2"

# testing
gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "database_cleaner", ">= 1.0.0.RC1", :group => :test
gem "mongoid-rspec", ">= 1.7.0", :group => :test
gem "email_spec", ">= 1.4.0", :group => :test
gem "cucumber-rails", ">= 1.3.1", :group => :test, :require => false
gem "launchy", ">= 2.2.0", :group => :test
gem "capybara", ">= 2.0.3", :group => :test
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem 'coveralls', require: false

# authentication
gem "omniauth", ">= 1.1.3"
gem "omniauth-google-oauth2"
gem "cancan", ">= 1.6.9"
gem "rolify", ">= 3.2.0"

# dev and debugging tools
gem "quiet_assets", ">= 1.0.2", :group => :development
gem "better_errors", ">= 0.7.2", :group => :development
gem "binding_of_caller", ">= 0.7.1", :group => :development, :platforms => [:mri_19, :rbx]

gem "geocoder", :git => 'git://github.com/alexreisner/geocoder.git'
gem "area"
gem "validates_formatting_of"
gem "redis"