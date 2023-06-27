# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'validation_profiler/version'

Gem::Specification.new do |spec|
  spec.name          = 'validation_profiler'
  spec.version       = ValidationProfiler::VERSION
  spec.authors       = ['Sage One']
  spec.email         = ['vaughan.britton@sage.com']

  spec.summary       = 'A Validation framework for creating validation profiles, allowing for the separation & reuse of validation logic from the object being validated.'
  spec.description   = 'A Validation framework for creating validation profiles, allowing for the separation & reuse of validation logic from the object being validated.'
  spec.homepage      = 'https://github.com/sage/validation_profiler'
  spec.license       = 'MIT'

  spec.files         = Dir.glob("{bin,lib}/**/**/**")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov', '< 0.18.0'
end
