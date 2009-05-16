class Language
  
  include DataMapper::Resource
  
  # properties
  
  property :id, Serial
  
  property :code, String, :nullable => false
  property :name, String, :nullable => false
  
  # locale string like 'en-US'
  validates_format :code, :with => /^[a-z]{2}-[A-Z]{2}$/
  
end