require "httparty"
Dir[File.dirname(__FILE__) + '/ohanakapa/*.rb'].each do |file|
  require file
end