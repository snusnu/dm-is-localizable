require 'spec_helper'
require 'shared/shared_examples_spec'

describe "class level API:" do

  describe "translation_model" do

    it "should follow naming conventions" do
      Item.i18n.translation_model.should == ItemTranslation
    end

  end

  describe "available_locales" do

    before :each do
      @item  = Item.create
      @provider = Item
    end

    it_should_behave_like "all available_locales providers"

  end

  describe "localizable_properties" do

    it "should return a list of symbols reflecting the localizable properties" do
      Item.i18n.localizable_properties.size.should == 2
      Item.i18n.localizable_properties.should include(:name)
      Item.i18n.localizable_properties.should include(:desc)
    end

  end

  describe "non_localizable_properties" do

    it "should return a list of symbols reflecting the names of all but localizable properties in the remixed translations model" do
      Item.i18n.non_localizable_properties.size.should == 3
      Item.i18n.non_localizable_properties.should include(:id)
      Item.i18n.non_localizable_properties.should include(:locale_id)
      Item.i18n.non_localizable_properties.should include(DataMapper::Inflector.foreign_key('Item').to_sym)
    end

  end

end
