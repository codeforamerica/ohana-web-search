source 'https://rubygems.org'

ruby '2.0.0'
gem 'rails', '3.2.13'

# front end
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', '>= 1.0.17'
gem 'requirejs-rails', git: 'git://github.com/jwhitley/requirejs-rails.git'
gem 'haml-rails'

# server
gem "unicorn", ">= 4.3.1"
gem 'newrelic_rpm'
gem 'ohanakapa', :git => "https://github.com/codeforamerica/ohanakapa-ruby.git", :branch => 'master' #for API wrapper

# app config and ENV variables for heroku
gem "figaro", ">= 0.6.3"

gem 'coveralls', require: false

# dev and debugging tools
group :development do
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
  gem "metric_fu"
end

group :test do
  gem "cucumber-rails", ">= 1.3.1", :require => false
  gem "launchy", ">= 2.2.0"
  gem "capybara", ">= 2.0.3"
  gem 'json'
  gem 'poltergeist'
end

group :development, :test do
  gem "teaspoon"
  gem "rspec-rails", ">= 2.12.2"
  gem 'yard' #for code documentation
end