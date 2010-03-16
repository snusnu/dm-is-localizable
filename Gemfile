source 'http://rubygems.org'

gem 'dm-core',           '~> 0.10.2', :git => 'git://github.com/snusnu/dm-core.git', :branch => 'active_support'

git 'git://github.com/snusnu/dm-more.git', :branch => 'active_support' do

  gem 'dm-validations',  '~> 0.10.2'
  gem 'dm-is-remixable', '~> 0.10.2'

end

group(:test) do
  gem 'rspec',           '~> 1.3', :require => 'spec'
end

group(:development) do
  gem 'rake',            '~> 0.8.7'
  gem 'jeweler',         '~> 1.4'
  gem 'yard',            '~> 0.5'
end
