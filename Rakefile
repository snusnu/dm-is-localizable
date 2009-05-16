require 'pathname'
require 'rubygems'
require 'rake'

ROOT = Pathname(__FILE__).dirname.expand_path
JRUBY = RUBY_PLATFORM =~ /java/

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "dm-is-localizable"
    gem.summary = %Q{Datamapper support for localization of content in multilanguage applications}
    gem.email = "gamsnjaga@gmail.com"
    gem.homepage = "http://github.com/snusnu/dm-is-localizable"
    gem.authors = ["Martin Gamsjaeger (snusnu)"]
    gem.add_dependency('dm-core',         '>= 0.9.11')
    gem.add_dependency('dm-is-remixable', '>= 0.9.11')
    gem.add_dependency('dm-validations',  '>= 0.9.11')
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  gem 'rspec', '>=1.1.12'
  require 'spec'
  require 'spec/rake/spectask'
 
  task :default => [ :spec ]
 
  desc 'Run specifications'
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
    t.spec_files = Pathname.glob((ROOT + 'spec/**/*_spec.rb').to_s).map { |f| f.to_s }
 
    begin
      gem 'rcov', '~>0.8'
      t.rcov = JRUBY ? false : (ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true)
      t.rcov_opts << '--exclude' << 'spec'
      t.rcov_opts << '--text-summary'
      t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
    rescue LoadError
      # rcov not installed
    end
  end
rescue LoadError
  # rspec not installed
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-is-localizable #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

