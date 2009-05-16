require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DataMapper::Is::Localizable do
  
  before :all do
    DataMapper.auto_migrate!
  end
  
  describe "Language" do

    describe "with valid attributes" do
    
      it "should be valid" do
        Language.new(:code => "en-US", :name => "English").should be_valid
      end
      
      it "should store unique locale string codes" do
        Language.create(:code => "en-US", :name => "English").should_not be_new_record
        Language.create(:code => "en-US", :name => "English").should be_new_record
      end
      
    end
        
    describe "with incomplete attributes" do
      
      before :each do
        @l = Language.new
      end
    
      it "should require a code" do
        @l.name = "English"
        @l.should_not be_valid
        @l.errors.size.should == 1
        @l.errors.on(:code).should_not be_empty
      end
        
      it "should require a name" do
        @l.code = "en-US"
        @l.should_not be_valid
        @l.errors.size.should == 1
        @l.errors.on(:name).should_not be_empty
      end
      
    end
    
    describe "with invalid attributes" do

      it "should not accept invalid locale strings" do
        Language.new(:code => 'foo',     :name => "English").should_not be_valid
        Language.new(:code => 'foo-bar', :name => "English").should_not be_valid
        Language.new(:code => 'foo-BAR', :name => "English").should_not be_valid
        Language.new(:code => 'FOO-bar', :name => "English").should_not be_valid
        Language.new(:code => 'FOO-BAR', :name => "English").should_not be_valid
        Language.new(:code => 'en-us',   :name => "English").should_not be_valid
        Language.new(:code => 'EN-us',   :name => "English").should_not be_valid
        Language.new(:code => 'EN-US',   :name => "English").should_not be_valid
      end

    end
    
  end
  
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
      @i = Item.create
      @l = Language.create :code => 'en', :name => 'English'
      @t = ItemTranslation.new :item => @i, :language => @l
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
  
  describe "class method API" do
    
    describe "translation_class" do
      
      it "should follow naming conventions" do
        Item.translation_class.should == ItemTranslation
      end
      
    end
    
    describe "available_languages" do
      
      describe "with no translations" do
      
        it "should return 0 languages" do
          Item.available_languages.size.should == 0
        end
        
      end
      
      describe "with 1 translation in 1 language" do
        
        before :each do
          @l = Language.create :code => 'en-US', :name => 'English'
          @i = Item.create
          @t = ItemTranslation.create :item_id => @i.id, :language_id => @l.id, :name => "Book", :desc => "Literature"
        end
      
        it "should return 1 language" do
          Item.available_languages.size.should == 1
        end
        
        it "should return the right language" do
          Item.available_languages.first.should == @l
        end
        
      end
      
      describe "with 2 translation in 1 language" do
        
        before :each do
          @l = Language.create :code => 'en-US', :name => 'English'
          @i = Item.create
          @t = ItemTranslation.create :item_id => @i.id, :language_id => @l.id, :name => "Book", :desc => "Literature"
          @t = ItemTranslation.create :item_id => @i.id, :language_id => @l.id, :name => "Hook", :desc => "Tool"
        end
      
        it "should return 1 language" do
          Item.available_languages.size.should == 1
        end
        
        it "should return the right language" do
          Item.available_languages.first.should == @l
        end
        
      end
      
      describe "with 3 translation in 2 language" do
        
        before :each do
          @l1 = Language.create :code => 'en-US', :name => 'English (US)'
          @l2 = Language.create :code => 'de-AT', :name => 'Deutsch (Österreich)'
          @i  = Item.create
          @t  = ItemTranslation.create :item_id => @i.id, :language_id => @l1.id, :name => "Book",  :desc => "Literature"
          @t  = ItemTranslation.create :item_id => @i.id, :language_id => @l1.id, :name => "Hook",  :desc => "Tool"
          @t  = ItemTranslation.create :item_id => @i.id, :language_id => @l2.id, :name => "Haken", :desc => "Werkzeug"
        end
      
        it "should return 2 language" do
          Item.available_languages.size.should == 2
        end
        
        it "should return the right language" do
          Item.available_languages.first.should == @l1
          Item.available_languages.last.should  == @l2
        end
        
      end
      
    end
    
  end
  
end
