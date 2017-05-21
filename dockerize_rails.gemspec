# frozen_string_literal: true
# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dockerize_rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'dockerize_rails'
  spec.version       = DockerizeRails::VERSION

  spec.authors       = ['indrajit']
  spec.email         = ['eendroroy@gmail.com']

  spec.summary       = 'A docker util for rails application'
  spec.description   = 'A docker util for rails application'
  spec.homepage      = 'https://github.com/eendroroy/dockerize_rails'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'

  unless spec.respond_to?(:metadata)
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'docker-api'
  spec.add_dependency 'colorize'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'yard'
end
