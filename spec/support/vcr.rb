VCR.configure do |c|
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.cassette_library_dir  = Rails.root.join("spec", "fixtures", "vcr_cassettes")
  c.hook_into :webmock
end

# http://railscasts.com/episodes/291-testing-with-vcr?view=asciicast
# This automatically names a vcr cassette based on the "feature"
# and "scenario" text.
# RSpec.configure do |c|
#   c.treat_symbols_as_metadata_keys_with_true_values = true
#   c.around(:each, :vcr) do |example|
#     name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
#     VCR.use_cassette(name) { example.call }
#   end
# end