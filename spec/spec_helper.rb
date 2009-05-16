require 'pathname'
require 'rubygems'
require 'spec'

gem 'dm-is-remixable', '>=0.9.11'
require 'dm-is-remixable'

gem 'dm-validations', '>=0.9.11'
require 'dm-validations'
 
require Pathname(__FILE__).dirname.parent.expand_path + 'lib/dm-is-localizable'
 
ENV["SQLITE3_SPEC_URI"]  ||= 'sqlite3::memory:'
ENV["MYSQL_SPEC_URI"]    ||= 'mysql://localhost/dm-accepts_nested_attributes_test'
ENV["POSTGRES_SPEC_URI"] ||= 'postgres://postgres@localhost/dm-accepts_nested_attributes_test'
 
 
def setup_adapter(name, default_uri = nil)
  begin
    DataMapper.setup(name, ENV["#{ENV['ADAPTER'].to_s.upcase}_SPEC_URI"] || default_uri)
    Object.const_set('ADAPTER', ENV['ADAPTER'].to_sym) if name.to_s == ENV['ADAPTER']
    true
  rescue Exception => e
    if name.to_s == ENV['ADAPTER']
      Object.const_set('ADAPTER', nil)
      warn "Could not load do_#{name}: #{e}"
    end
    false
  end
end

ENV['ADAPTER'] ||= 'sqlite3'
setup_adapter(:default)
Dir[Pathname(__FILE__).dirname.to_s + "/fixtures/**/*.rb"].each { |rb| require(rb) }

# have the loggers handy
# DataObjects::Logger.new(STDOUT, :debug)
# DataObjects::Sqlite3.logger = DataObjects::Logger.new(STDOUT, :debug)


Spec::Runner.configure do |config|
  
  config.before do
    DataMapper.repository(:default) do |r|
      transaction = DataMapper::Transaction.new(r)
      transaction.begin
      r.adapter.push_transaction(transaction)
    end
  end
  
  config.after do
    DataMapper.repository(:default) do |r|
      adapter = r.adapter
      while adapter.current_transaction
        adapter.current_transaction.rollback
        adapter.pop_transaction
      end
    end
  end
  
end
