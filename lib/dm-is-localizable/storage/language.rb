class Language

  include DataMapper::Resource

  # properties

  property :id, Serial

  property :code, String, :nullable => false, :unique => true, :unique_index => true
  property :name, String, :nullable => false

  # locale string like 'en-US'
  validates_format :code, :with => /^[a-z]{2}-[A-Z]{2}$/
  
  
  def self.[](code)
    return nil if code.nil?
    first :code => code.to_s.gsub('_', '-')
  end

end
