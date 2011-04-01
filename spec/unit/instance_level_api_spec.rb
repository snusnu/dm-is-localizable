require 'spec_helper'
require 'shared/shared_examples_spec'


describe "instance level API:" do

  it "should create a one_to_many association that follows naming conventions" do
    Item.new.should respond_to :item_translations
  end

  it "should add a translations alias to the one_to_many association" do
    Item.new.should respond_to :translations
  end

  it "should create a many_to_many association to locales" do
    Item.new.should respond_to :locales
  end

  describe "available_locales" do

    before :each do
      @item  = Item.create
      @provider = @item
    end

    it_should_behave_like "all available_locales providers"

  end


  describe "nr_of_available_locales" do

    before :each do
      @l1 = Locale.create :tag => 'en-US', :name => 'English'
      @l2 = Locale.create :tag => 'de-AT', :name => 'Deutsch'
      @i1 = Item.create
    end

    describe "with 0 translations" do

      it "should return 0" do
        @i1.nr_of_available_locales.should == 0
      end

    end

    describe "with 1 translation" do

      it "should return 1" do
        ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
        @i1.nr_of_available_locales == 1
      end

    end

    describe "with 2 translations in 1 locale" do

      it "should return 1" do
        ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
        ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
        @i1.nr_of_available_locales == 1
      end

    end

    describe "with 2 translations in 2 locales" do

      it "should return 2" do
        ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
        ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Book', :desc => 'Literature'
        @i1.nr_of_available_locales == 2
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
          l = Locale.create :tag => 'en-US', :name => 'English'
          ItemTranslation.create :item => @i1, :locale => l, :name => 'Book', :desc => 'Literature'
          @i1.translations_complete?.should be_true
        end

      end

      describe "and more than 1 translation" do

        it "should return true" do
          l1 = Locale.create :tag => 'en-US', :name => 'English'
          l2 = Locale.create :tag => 'de-AT', :name => 'Deutsch'
          ItemTranslation.create :item => @i1, :locale => l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i1, :locale => l2, :name => 'Buch', :desc => 'Literatur'
          @i1.translations_complete?.should be_true
        end

      end

    end

    describe "with 2 items" do

      before :each do
        @l1 = Locale.create :tag => 'en-US', :name => 'English'
        @l2 = Locale.create :tag => 'de-AT', :name => 'Deutsch'
        @i1 = Item.create
        @i2 = Item.create
      end

      describe "both having 1 translation into different locales" do

        it "should return false" do
          ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i2, :locale => @l2, :name => 'Buch', :desc => 'Literatur'
          @i1.translations_complete?.should be_false
          @i2.translations_complete?.should be_false
        end

      end

      describe "both having 1 translation into all different locales" do

        it "should return true" do
          ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book',  :desc => 'Literature'
          ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Buch',  :desc => 'Literatur'
          ItemTranslation.create :item => @i2, :locale => @l1, :name => 'Hook',  :desc => 'Tool'
          ItemTranslation.create :item => @i2, :locale => @l2, :name => 'Haken', :desc => 'Werkzeug'
          @i1.translations_complete?.should be_true
          @i2.translations_complete?.should be_true
        end

      end

    end

  end

  describe "translate(attribute, locale_code)" do

    before :each do
      @l1 = Locale.create :tag => 'en-US', :name => 'English'
      @l2 = Locale.create :tag => 'de-AT', :name => 'Deutsch'
      @i1 = Item.create
      @t1 = ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
      @t2 = ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Buch', :desc => 'Literatur'
    end

    describe "with an existing attribute" do

      describe "and an existing locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.translate(:name, :en_US).should == 'Book'
            @i1.translate(:desc, :en_US).should == 'Literature'
            @i1.translate(:name, :de_AT).should == 'Buch'
            @i1.translate(:desc, :de_AT).should == 'Literatur'
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.translate(:name, 'en_US').should == 'Book'
            @i1.translate(:desc, 'en_US').should == 'Literature'
            @i1.translate(:name, 'de_AT').should == 'Buch'
            @i1.translate(:desc, 'de_AT').should == 'Literatur'
          end

        end

      end

      describe "and a non existent locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.translate(:name, :it).should be_nil
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.translate(:name, 'it').should be_nil
          end

        end

      end

    end

    describe "with a non existent attribute" do

      describe "and an existing locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.translate(:foo, :en_US).should be_nil
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.translate(:foo, 'en_US').should be_nil
          end

        end

      end

      describe "and a non existent locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.translate(:foo, :it).should be_nil
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.translate(:foo, 'it').should be_nil
          end

        end

      end

    end

  end

  describe "property_name(locale_code)" do

    before :each do
      @l1 = Locale.create :tag => 'en-US', :name => 'English'
      @l2 = Locale.create :tag => 'de-AT', :name => 'Deutsch'
      @i1 = Item.create
      @t1 = ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
      @t2 = ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Buch', :desc => 'Literatur'
    end

    describe "with a nil locale_code" do

      it "should return nil" do
        @i1.name(nil).should be_nil
      end

    end

    describe "with a non existent locale_code" do

      describe "passed as Symbol" do

        it "should return nil" do
          @i1.name(:it).should be_nil
        end

      end

      describe "passed as String" do

        it "should return nil" do
          @i1.name('it').should be_nil
        end

      end

    end

    describe "with an existing locale_code" do

      describe "passed as Symbol" do

        it "should return the translated property" do
          @i1.name(:en_US).should == 'Book'
          @i1.desc(:en_US).should == 'Literature'
          @i1.name(:de_AT).should == 'Buch'
          @i1.desc(:de_AT).should == 'Literatur'
        end

      end

      describe "passed as String" do

        it "should return the translated property" do
          @i1.name('en_US').should == 'Book'
          @i1.desc('en_US').should == 'Literature'
          @i1.name('de_AT').should == 'Buch'
          @i1.desc('de_AT').should == 'Literatur'
        end

      end

    end

  end

end
