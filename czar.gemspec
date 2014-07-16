# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'czar/version'

Gem::Specification.new do |spec|
  spec.name          = "czar"
  spec.version       = Czar::VERSION
  spec.authors       = ["Rahoul Baruah"]
  spec.email         = ["rahoul@3hv.co.uk"]
  spec.summary       = "A framework for implementing the Command pattern"
  spec.description   = "Persistent, hierarchical commands"
  spec.homepage      = "http://passiverecord.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
end
