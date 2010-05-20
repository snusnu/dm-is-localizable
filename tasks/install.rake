desc "Install gem using sudo"
task :install => :build do
  puts '-' * 65
  puts ' Put the following model definition in a file called language.rb'
  puts '-' * 65
  File.open(ROOT.join('lib/dm-is-localizable/storage/language.rb')).each do |line|
    puts line
  end
end
