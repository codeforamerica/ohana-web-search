# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ohanakapa/version'

Gem::Specification.new do |spec|
  spec.name          = "ohanakapa"
  spec.version       = Ohanakapa::VERSION
  spec.authors       = ["Anselm Bradford", "Moncef Belyamani", "Sophia Parafina"]
  spec.email         = ["ohana@codeforamerica.org"]
  spec.description   = %q{A Ruby interface to the Ohana API.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/codeforamerica/ohanakapa"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '~> 0.11.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rspec", ">= 2.11"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock"

  spec.post_install_message = "Connect to Ohana. Connect your Community."
end
