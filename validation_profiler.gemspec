# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

####################
#### Set GEM Version based on GIT Release TAG when built with Codeship
####################
version = ''
if ENV['TRAVIS_TAG'] != nil
  puts "CI Branch - '#{ENV['TRAVIS_TAG']}'"
  version = ENV['TRAVIS_TAG']
end

#if the tag version starts with v (e.g. vx.x.x)
if version.downcase.match /^v/
  #trim the v and set the version to x.x.x
  version = version.dup
  version.slice!(0)
elsif ENV['TRAVIS_TAG'] != nil && ENV['TRAVIS_TAG'] != ''
  version = "0.0.0.#{ENV['TRAVIS_TAG']}"
else
  #otherwise it is not a valid release tag so set the version 0.0.0 as it not being released.
  version = '0.0.0'
end

Gem::Specification.new do |spec|
  spec.name          = "validation_profiler"
  spec.version       = version
  spec.authors       = ["vaughanbrittonsage"]
  spec.email         = ["vaughanbritton@gmail.com"]

  spec.summary       = 'A Validation framework for creating validation profiles, allowing for the separation & reuse of validation logic from the object being validated.'
  spec.description   = 'A Validation framework for creating validation profiles, allowing for the separation & reuse of validation logic from the object being validated.'
  spec.homepage      = "https://github.com/vaughanbrittonsage/validation_profiler"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{bin,lib}/**/**/**")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
