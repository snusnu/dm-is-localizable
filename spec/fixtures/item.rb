class Item

  include DataMapper::Resource

  property :id, Serial

  translatable do
    property :name, String
    property :desc, String
  end

end
