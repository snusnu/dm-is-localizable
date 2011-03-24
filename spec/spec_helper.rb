require 'dm-is-localizable'
require 'dm-core/spec/setup'
require 'fixtures/item'

DataMapper::Spec.setup

include DataMapper::I18n

Spec::Runner.configure do |config|

  config.before(:each) do
    DataMapper.auto_migrate!
  end

  config.after(:suite) do
    if DataMapper.respond_to?(:auto_migrate_down!, true)
      DataMapper.send(:auto_migrate_down!, DataMapper::Spec.adapter.name)
    end
  end

end
