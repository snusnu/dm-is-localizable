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
            @i1.i18n.translate(:name, :'en-US').should == 'Book'
            @i1.i18n.translate(:desc, :'en-US').should == 'Literature'
            @i1.i18n.translate(:name, :'de-AT').should == 'Buch'
            @i1.i18n.translate(:desc, :'de-AT').should == 'Literatur'
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.i18n.translate(:name, 'en-US').should == 'Book'
            @i1.i18n.translate(:desc, 'en-US').should == 'Literature'
            @i1.i18n.translate(:name, 'de-AT').should == 'Buch'
            @i1.i18n.translate(:desc, 'de-AT').should == 'Literatur'
          end

        end

      end

      describe "and a non existent locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.i18n.translate(:name, :it).should be_nil
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.i18n.translate(:name, 'it').should be_nil
          end

        end

      end

    end

    describe "with a non existent attribute" do

      describe "and an existing locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.i18n.translate(:foo, :'en-US').should be_nil
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.i18n.translate(:foo, 'en-US').should be_nil
          end

        end

      end

      describe "and a non existent locale_code" do

        describe "passed as Symbol" do

          it "should return the translated string" do
            @i1.i18n.translate(:foo, :it).should be_nil
          end

        end

        describe "passed as String" do

          it "should return the translated string" do
            @i1.i18n.translate(:foo, 'it').should be_nil
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
          @i1.name(:'en-US').should == 'Book'
          @i1.desc(:'en-US').should == 'Literature'
          @i1.name(:'de-AT').should == 'Buch'
          @i1.desc(:'de-AT').should == 'Literatur'
        end

      end

      describe "passed as String" do

        it "should return the translated property" do
          @i1.name('en-US').should == 'Book'
          @i1.desc('en-US').should == 'Literature'
          @i1.name('de-AT').should == 'Buch'
          @i1.desc('de-AT').should == 'Literatur'
        end

      end

    end

  end

end
