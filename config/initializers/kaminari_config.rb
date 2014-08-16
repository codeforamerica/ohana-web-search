# See the Kaminari README for more details about these options:
# https://github.com/amatsuda/kaminari#helpers
Kaminari.configure do |config|
  # If the value of DEFAULT_PER_PAGE in your instance of the Ohana API
  # is not "30", change "30" below to match your API's value.
  config.default_per_page = Rails.env.test? ? 1 : 30

  config.window = 2
  config.outer_window = 1
  # config.left = 0
  # config.right = 0
end
