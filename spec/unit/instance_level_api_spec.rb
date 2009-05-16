require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../shared/shared_examples_spec')


describe "instance level API:" do
  
  it "should create a one_to_many association that follows naming conventions" do
    Item.new.should respond_to :item_translations
  end
  
  it "should add a translations alias to the one_to_many association" do
    Item.new.should respond_to :translations
  end
  
  it "should create a many_to_many association to languages" do
    Item.new.should respond_to :languages
  end
  
  describe "available_languages" do
    
    before :each do
      @item  = Item.create
      @provider = @item
    end
    
    it_should_behave_like "all available_languages providers"
    
  end
  
  
  describe "nr_of_available_languages" do
    
    before :each do
      @l1 = Language.create :code => 'en-US', :name => 'English'
      @l2 = Language.create :code => 'de-AT', :name => 'Deutsch'
      @i1 = Item.create
    end
    
    describe "with 0 translations" do
      
      it "should return 0" do
        @i1.nr_of_available_languages.should == 0
      end
      
    end
    
    describe "with 1 translation" do
      
      it "should return 1" do
        ItemTranslation.create :item => @i1, :language => @l1, :name => 'Book', :desc => 'Literature'
        @i1.nr_of_available_languages == 1
      end
      
    end

    describe "with 2 translations in 1 language" do
      
      it "should return 1" do
        ItemTranslation.create :item => @i1, :language => @l1, :name => 'Book', :desc => 'Literature'
        ItemTranslation.create :item => @i1, :language => @l1, :name => 'Book', :desc => 'Literature'
        @i1.nr_of_available_languages == 1
      end
      
    end
        
    describe "with 2 translations in 2 language" do
      
      it "should return 2" do
        ItemTranslation.create :item => @i1, :language => @l1, :name => 'Book', :desc => 'Literature'
        ItemTranslation.create :item => @i1, :language => @l2, :name => 'Book', :desc => 'Literature'
        @i1.nr_of_available_languages == 2
      end
      
    end
    
  end
  
    
  describe "translations_complete?" do
    
    describe "with 1 item" do
      
      before :each do
        @i1 = Item.create
      end
  
      describe "and 0 translations" do
      
        it "should return true" do
          @i1.translations_complete?.should be_true
        end
      
      end
              
      describe "and 1 translation" do
      
        it "should return true" do
          l = Language.create :code => 'en-US', :name => 'English'
          ItemTranslation.create :item => @i1, :language => l, :name => 'Book', :desc => 'Literature'
          @i1.translations_complete?.should be_true
        end
      
      end
            
      describe "and more than 1 translation" do
      
        it "should return true" do
          l1 = Language.create :code => 'en-US', :name => 'English'
          l2 = Language.create :code => 'de-AT', :name => 'Deutsch'
          ItemTranslation.create :item => @i1, :language => l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i1, :language => l2, :name => 'Buch', :desc => 'Literatur'
          @i1.translations_complete?.should be_true
        end
      
      end
      
    end
    
    describe "with 2 items" do
      
      before :each do
        @l1 = Language.create :code => 'en-US', :name => 'English'
        @l2 = Language.create :code => 'de-AT', :name => 'Deutsch'
        @i1 = Item.create
        @i2 = Item.create
      end
      
      describe "both having 1 translation into different languages" do

        it "should return false" do
          ItemTranslation.create :item => @i1, :language => @l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i2, :language => @l2, :name => 'Buch', :desc => 'Literatur'
          @i1.translations_complete?.should be_false
          @i2.translations_complete?.should be_false
        end

      end
      
      describe "both having 1 translation into all different languages" do

        it "should return true" do
          ItemTranslation.create :item => @i1, :language => @l1, :name => 'Book',  :desc => 'Literature'
          ItemTranslation.create :item => @i1, :language => @l2, :name => 'Buch',  :desc => 'Literatur'
          ItemTranslation.create :item => @i2, :language => @l1, :name => 'Hook',  :desc => 'Tool'
          ItemTranslation.create :item => @i2, :language => @l2, :name => 'Haken', :desc => 'Werkzeug'
          @i1.translations_complete?.should be_true
          @i2.translations_complete?.should be_true
        end

      end
      
    end
    
  end
  
end