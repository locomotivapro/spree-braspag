# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_braspag'
  s.version     = '1.1.10'
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

  s.add_dependency 'spree_core', '~> 1.1.5'
  s.add_dependency 'baby-braspag', '~> 0.1.3'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-fsevent', '~> 0.9.1'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'sqlite3'
end
