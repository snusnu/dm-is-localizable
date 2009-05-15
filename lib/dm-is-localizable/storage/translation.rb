module Translation
  
  include DataMapper::Resource
  
  is :remixable
  
  property :id,          Serial
  property :language_id, Integer, :nullable => false
  
end