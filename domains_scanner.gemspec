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
  spec.bindir        = "bin"
  spec.executables   << 'domains_scanner'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'byebug', '~> 9.1'

  spec.add_dependency 'mechanize', '~> 2.7', '>= 2.7.5'
end
