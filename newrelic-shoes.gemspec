# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic/shoes/version'

Gem::Specification.new do |spec|
  spec.name          = "newrelic-shoes"
  spec.version       = NewRelic::Shoes::VERSION
  spec.authors       = ["Jason R. Clark"]
  spec.email         = ["jason@jasonclark.net"]

  spec.summary       = %q{Use New Relic to trace Shoes.}
  spec.homepage      = "https://github.com/jasonrclark/newrelic-shoes."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "newrelic_rpm"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
