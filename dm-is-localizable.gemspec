# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dm-is-localizable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = [ 'Martin Gamsjaeger (snusnu)' ]
  gem.email       = [ 'gamsnjaga@gmail.com' ]
  gem.summary     = "A DataMapper plugin that supports storing localized content in multilanguage applications"
  gem.description = gem.summary
  gem.homepage    = "http://github.com/snusnu/dm-is-localizable"

  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.textile]

  gem.name          = "dm-is-localizable"
  gem.require_paths = [ "lib" ]
  gem.version       = DataMapper::I18n::VERSION

  gem.add_runtime_dependency('dm-core',                      '~> 1.2')
  gem.add_runtime_dependency('dm-validations',               '~> 1.2')
  gem.add_runtime_dependency('dm-accepts_nested_attributes', '~> 1.1.0')

  gem.add_development_dependency('dm-constraints',           '~> 1.2')
  gem.add_development_dependency('rake',                     '~> 0.9.2')
  gem.add_development_dependency('rspec',                    '~> 1.3.2')
end
