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

    gem.add_dependency 'dm-core',           '~> 1.0.0.rc1'
    gem.add_dependency 'dm-is-remixable',   '~> 1.0.0.rc1'
    gem.add_dependency 'dm-validations',    '~> 1.0.0.rc1'

    gem.add_development_dependency 'rspec', '~> 1.3'
    gem.add_development_dependency 'yard',  '~> 0.5'

    Jeweler::GemcutterTasks.new

    FileList['tasks/**/*.rake'].each { |task| import task }

  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
