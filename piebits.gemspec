# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'piebits/version'

Gem::Specification.new do |spec|
  spec.name          = "piebits"
  spec.version       = Piebits::VERSION
  spec.authors       = ["Brian Hardy"]
  spec.email         = ["brian@bignerdranch.com"]

  spec.summary       = %q{Client for submitting content to the piebits.com service.}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "http://piebits.com"
  spec.license       = "MIT"
  
  spec.required_ruby_version = '>= 2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "faraday", "~> 0.9.1"
    
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
