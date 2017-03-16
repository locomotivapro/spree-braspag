# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree/braspag/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_braspag'
  s.version     = Spree::Braspag::VERSION
  s.summary     = 'Gem for integration of spree and braspag payment gateways'
  s.description = 'Gem for integration of spree and braspag payment gateways'
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Locomotiva.pro'
  s.email     = 'contato@locomotiva.pro'
  s.homepage  = 'http://locomotiva.pro'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'spree_core', '~> 3.1.0.beta'
  s.add_runtime_dependency 'braspag-rest' #, '~> 0.5.2'

  s.add_development_dependency 'pg'
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'

end
