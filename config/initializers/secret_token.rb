# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
  fail 'The SECRET_TOKEN environment variable is not set on your production' \
  ' server. To generate a random token, run "rake secret" from the command' \
  ' line, then set it in production. If you\'re using Heroku, you can set it' \
  ' like this: "heroku config:set SECRET_TOKEN=the_token_you_generated".'
end

Rails.application.config.secret_key_base = ENV['SECRET_TOKEN'] || 'fb469c50a3390dfe017847d6127c40f059bb9bf7bb729b7b9af69b89af9c8e3e234122873d0d5a1ec343461077d03a981922f9954922a5d0f21188341de8832f'
