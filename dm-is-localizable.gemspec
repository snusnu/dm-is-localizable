# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name        = 'dm-is-localizable'
  gem.version     = '1.0.1'
  gem.authors     = [ 'Martin Gamsjaeger (snusnu)' ]
  gem.email       = [ 'gamsnjaga@gmail.com' ]
  gem.description = 'Content localization for DataMapper'
  gem.summary     = 'DataMapper support for localization of content in multilanguage applications'
  gem.homepage    = 'https://github.com/snusnu/dm-is-localizable'

  gem.require_paths    = [ "lib" ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.textile TODO]
  gem.license          = 'MIT'

  gem.add_dependency 'dm-core',        '~> 1.2.0'
  gem.add_dependency 'dm-validations', '~> 1.2.0'

  gem.add_development_dependency 'bundler', '~> 1.3.5'
end
