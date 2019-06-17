# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'validates_timeliness/mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = 'validates_timeliness-mongoid'
  spec.version       = ValidatesTimeliness::Mongoid::VERSION
  spec.authors       = ['Adam Meehan']
  spec.email         = ['adam.meehan@gmail.com']

  spec.summary       = 'ValidatesTimeliness mongoid extension'
  spec.description   = 'ValidatesTimeliness mongoid ORM compatability'
  spec.homepage      = 'https://github.com/diowa/validates_timeliness-mongoid'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'validates_timeliness', '~> 4.0'

  spec.add_development_dependency 'bundler', '>= 1.17', '< 3'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.71.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.33'
end
