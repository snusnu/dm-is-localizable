require 'dm-is-localizable'
require 'dm-core/spec/setup'

# MUST happen before requiring model definitions
require 'dm-constraints' if ENV['DM_CONSTRAINTS']

require 'fixtures/item' # the model definitions

# Have a logger handy but mostly very quiet
# Must be done before DataMapper::Spec.setup
DataMapper::Logger.new($stdout, :fatal)

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

# Allow glimpses of SQL to shine through
def with_dm_logger(level = :debug)
  DataMapper.logger.level = DataMapper::Logger::Levels[level]
  yield
ensure
  DataMapper.logger.level = DataMapper::Logger::Levels[:fatal]
end
