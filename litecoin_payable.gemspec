# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'litecoin_payable/version'

Gem::Specification.new do |spec|
  spec.name          = "litecoin_payable"
  spec.version       = LitecoinPayable::VERSION
  spec.authors       = ["Tim Kretschmer"]
  spec.email         = ["tim@krtschmr.de"]
  spec.description   = %q{A Litecoin payment processor}
  spec.summary       = %q{A Litecoin payment processor}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'sqlite3'

  spec.required_rubygems_version = '>= 1.3.6'

  spec.add_dependency "rails"
  spec.add_dependency "cucumber-rails"
  spec.add_dependency "rspec-rails"
  spec.add_dependency "database_cleaner"
  spec.add_dependency "state_machine"
  spec.add_dependency "blockcypher-ruby"
  spec.add_dependency "money-tree"
end
