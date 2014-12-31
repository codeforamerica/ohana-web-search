require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.ignore_hosts '127.0.0.1', 'localhost'
  config.default_cassette_options = { record: :once }
  config.cassette_library_dir  = 'spec/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<GOOGLE_TRANSLATE>') do
    ENV['GOOGLE_TRANSLATE_API_KEY']
  end
  config.before_record do |c|
    c.response.body.force_encoding('UTF-8')
  end
end
