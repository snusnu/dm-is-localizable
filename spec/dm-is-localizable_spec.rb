require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DataMapper::Is::Localizable do
  
  describe "automigration" do
  
    it "should allow to automigrate the resource to be translated" do
      lambda { Item.auto_migrate! }.should_not raise_error
    end
    
    it "should allow to automigrate the resource where translations will be stored" do
      lambda { ItemTranslation.auto_migrate! }.should_not raise_error
    end
  
  end
  
  describe "DataMapper::Model.is_localizable with no options" do
    
    before :each do
      Language.auto_migrate!
      Item.auto_migrate!
      ItemTranslation.auto_migrate!
      
      @item = Item.create
      @language = Language.create :code => 'en', :name => 'English'
      @t = ItemTranslation.new :item => @item, :language => @language
    end
    
    it "should belong_to a resource" do
      @t.respond_to?(:item).should == true
      @t.item.should be_instance_of(Item)
    end
      
    it "should belong_to a language" do
      @t.respond_to?(:language).should == true
      @t.language.should be_instance_of(Language)
      @t.language.code.should == 'en'
      @t.language.name.should == 'English'
    end
    
    it "should store properties defined inside the block in the translations resource" do
      @t.respond_to?(:name).should == true
      @t.respond_to?(:desc).should == true
    end
    
  end
  
end
