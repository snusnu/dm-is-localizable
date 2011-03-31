require 'spec_helper'
require 'shared/shared_examples_spec'

describe "class level API:" do

  describe "translation_model" do

    it "should follow naming conventions" do
      Item.translation_model.should == ItemTranslation
    end

  end

  describe "available_locales" do

    before :each do
      @item  = Item.create
      @provider = Item
    end

    it_should_behave_like "all available_locales providers"

  end

  describe "nr_of_available_locales" do

    describe "with 0 items" do

      it "should return 0" do
        Item.nr_of_available_locales.should == 0
      end

    end

    describe "with 1 item" do

      before :each do
        @l1 = Locale.create :locale => 'en-US', :name => 'English'
        @l2 = Locale.create :locale => 'de-AT', :name => 'Deutsch'
        @i1 = Item.create
      end

      describe "and 0 translations" do

        it "should return 0" do
          Item.nr_of_available_locales == 0
        end

      end

      describe "and 1 translation" do

        it "should return 1" do
          ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
          Item.nr_of_available_locales == 1
        end

      end

      describe "and 2 translations" do

        it "should return 2" do
          ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Book', :desc => 'Literature'
          Item.nr_of_available_locales == 2
        end

      end

    end

  end


  describe "translations_complete?" do

    describe "with 0 items" do

      it "should return true" do
        Item.translations_complete?.should be_true
      end

    end

    describe "with 1 item" do

      before :each do
        @i1 = Item.create
        @provider = Item
      end

      describe "and 0 translations" do

        it "should return true" do
          Item.translations_complete?.should be_true
        end

      end

      describe "and 1 translation" do

        it "should return true" do
          l = Locale.create :locale => 'en-US', :name => 'English'
          ItemTranslation.create :item => @i1, :locale => l, :name => 'Book', :desc => 'Literature'
          Item.translations_complete?.should be_true
        end

      end

      describe "and more than 1 translation" do

        it "should return true" do
          l1 = Locale.create :locale => 'en-US', :name => 'English'
          l2 = Locale.create :locale => 'de-AT', :name => 'Deutsch'
          ItemTranslation.create :item => @i1, :locale => l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i1, :locale => l2, :name => 'Buch', :desc => 'Literatur'
          Item.translations_complete?.should be_true
        end

      end

    end

    describe "with 2 items" do

      before :each do
        @l1 = Locale.create :locale => 'en-US', :name => 'English'
        @l2 = Locale.create :locale => 'de-AT', :name => 'Deutsch'
        @i1 = Item.create
        @i2 = Item.create
      end

      describe "and not all items are translated" do

        it "should return false" do
          ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book', :desc => 'Literature'
          ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Buch', :desc => 'Literatur'
          Item.translations_complete?.should be_false
        end

      end

      describe "and all items are translated" do

        it "should return true" do
          ItemTranslation.create :item => @i1, :locale => @l1, :name => 'Book',  :desc => 'Literature'
          ItemTranslation.create :item => @i1, :locale => @l2, :name => 'Buch',  :desc => 'Literatur'
          ItemTranslation.create :item => @i2, :locale => @l1, :name => 'Hook',  :desc => 'Tool'
          ItemTranslation.create :item => @i2, :locale => @l2, :name => 'Haken', :desc => 'Werkzeug'
          Item.translations_complete?.should be_true
        end

      end

    end

  end

  describe "localizable_properties" do

    it "should return a list of symbols reflecting the localizable properties" do
      Item.localizable_properties.size.should == 2
      Item.localizable_properties.should include(:name)
      Item.localizable_properties.should include(:desc)
    end

  end

  describe "non_localizable_properties" do

    it "should return a list of symbols reflecting the names of all but localizable properties in the remixed translations model" do
      Item.non_localizable_properties.size.should == 3
      Item.non_localizable_properties.should include(:id)
      Item.non_localizable_properties.should include(:locale_id)
      Item.non_localizable_properties.should include(DataMapper::Inflector.foreign_key('Item').to_sym)
    end

  end

end
