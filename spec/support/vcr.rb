VCR.configure do |c|
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.default_cassette_options = { :record => :new_episodes }
  c.cassette_library_dir  = Rails.root.join("spec", "fixtures", "vcr_cassettes")
  c.hook_into :webmock
end
