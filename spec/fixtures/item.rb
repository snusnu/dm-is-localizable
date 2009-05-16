class Item

  include DataMapper::Resource

  property :id, Serial

  is :localizable do
    property :name, String
    property :desc, String
  end

end
