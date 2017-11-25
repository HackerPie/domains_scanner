# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'domains_scanner/version'

Gem::Specification.new do |spec|
  spec.name          = "domains_scanner"
  spec.version       = DomainsScanner::VERSION
  spec.authors       = ["Martin Hong"]
  spec.email         = ["hongzeqin@gmail.com"]

  spec.summary       = %q{search possible domains for specified keyword}
  spec.description   = %q{search possible domains by search engines and other tools}
  spec.homepage      = "https://rubygems.org/gems/domains_scanner"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end