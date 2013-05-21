# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
	raise 'The SECRET_TOKEN environment variable is not set.\n
	To generate it, run "rake secret", then set it with "heroku config:set SECRET_TOKEN=the_token_you_generated"'
end

HumanServicesFinder::Application.config.secret_token = ENV['SECRET_TOKEN'] || 'fb469c50a3390dfe017847d6127c40f059bb9bf7bb729b7b9af69b89af9c8e3e234122873d0d5a1ec343461077d03a981922f9954922a5d0f21188341de8832f'
