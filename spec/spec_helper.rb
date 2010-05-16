require 'dm-is-localizable'
require 'dm-transactions'
require 'dm-core/spec/setup'
require 'fixtures/item'

DataMapper::Spec.setup

Spec::Runner.configure do |config|

  config.before(:each) do
    DataMapper.auto_migrate!
  end

end
