# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.2'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are
# already added.
#
# Include Internet Explorer polyfills.
Rails.application.config.assets.precompile +=
  %w(vendor.js ie8.js ie9.js routes/home/index.js routes/locations/index.js
     routes/locations/show.js routes/about/index.js)
