require 'pathname'
require 'rake'


begin

  require 'jeweler'

  Jeweler::Tasks.new do |gem|

    gem.name = "dm-is-localizable"
    gem.summary = %Q{Datamapper support for localization of content in multilanguage applications}
    gem.email = "gamsnjaga@gmail.com"
    gem.homepage = "http://github.com/snusnu/dm-is-localizable"
    gem.authors = ["Martin Gamsjaeger (snusnu)"]

    gem.add_dependency('dm-core',           '~> 0.10.2')
    gem.add_dependency('dm-is-remixable',   '~> 0.10.2')
    gem.add_dependency('dm-validations',    '~> 0.10.2')

    gem.add_development_dependency 'rspec', '~> 1.3'
    gem.add_development_dependency 'yard',  '~> 0.5'

    Jeweler::GemcutterTasks.new

  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

# require all tasks below tasks
ROOT = Pathname(__FILE__).dirname.expand_path
Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }
