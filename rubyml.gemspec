# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubyml/version'

Gem::Specification.new do |spec|
  spec.name          = "rubyml"
  spec.version       = Rubyml::VERSION
  spec.authors       = ["Saleem Ansari"]
  spec.email         = ["tuxdna@gmail.com"]
  spec.summary       = %q{Ruby Machine Learning Examples}
  spec.description   = %q{Machine Learing techniques in Ruby}
  spec.homepage      = "https://github.com/tuxdna"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency 'nokogiri', '~> 1.6', '>= 1.6.1'
  spec.add_runtime_dependency 'json', '~> 1.7', '>= 1.7.3'
end
