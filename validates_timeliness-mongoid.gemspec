# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'validates_timeliness/mongoid/info'

Gem::Specification.new do |spec|
  version = ValidatesTimeliness::Mongoid::VERSION
  spec.version       = if ENV.key?('GITHUB_RUN_ID') &&
                          !ENV['GITHUB_REF'].eql?('refs/heads/master')
                         "#{version}.pre.#{ENV['GITHUB_RUN_ID']}"
                       else
                         version
                       end

  spec.name          = ValidatesTimeliness::Mongoid::GEM_NAME
  spec.authors       = ValidatesTimeliness::Mongoid::AUTHORS
  spec.email         = ValidatesTimeliness::Mongoid::EMAILS

  spec.summary       = ValidatesTimeliness::Mongoid::SUMMARY
  spec.description   = ValidatesTimeliness::Mongoid::DESCRIPTION

  spec.homepage      = ValidatesTimeliness::Mongoid::HOMEPAGE
  spec.license       = ValidatesTimeliness::Mongoid::LICENSE

  spec.files         = ['Gemfile', 'Rakefile', 'README.md', 'LICENSE']
  spec.files         += Dir['lib/**/*']
  spec.files         += Dir['spec/**/*']

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_development_dependency 'bundler', '~> 2.2', '<= 2.2.16'
  spec.add_development_dependency 'faker', '~> 2.17'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.3'
  spec.add_development_dependency 'reek', '~> 6.0.4'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.13.0'
  spec.add_development_dependency 'rubocop-faker', '~> 1.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11', '>= 1.11.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'simplecov_json_formatter', '~> 0.1.3'

  spec.add_dependency 'mongoid', '~> 7.1', '< 7.2'
  spec.add_dependency 'validates_timeliness', '~> 5.0'
end
