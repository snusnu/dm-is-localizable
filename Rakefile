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

    Jeweler::GemcutterTasks.new
    FileList['tasks/**/*.rake'].each { |task| import task }
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
