class Language
  
  include DataMapper::Resource
  
  # properties
  
  property :id, Serial
  
  property :code, String, :nullable => false
  property :name, String, :nullable => false
  
end