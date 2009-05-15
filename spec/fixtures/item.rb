class Item

  include DataMapper::Resource

  property :id, Serial

  is :localizable do
    property :name, String, :nullable => false
    property :desc, String, :nullable => false
  end

end