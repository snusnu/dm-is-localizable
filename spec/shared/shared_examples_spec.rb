require 'spec_helper'

describe "all available_locales providers", :shared => true do

  describe "with no translations" do

    it "should return 0 locales" do
      @provider.i18n.available_locales.size.should == 0
    end

  end

  describe "with 1 translation in 1 locale" do

    before :each do
      @l = Locale.create :tag => 'en-US', :name => 'English'
      ItemTranslation.create :item => @item, :locale => @l, :name => "Book", :desc => "Literature"
    end

    it "should return 1 locale" do
      @provider.i18n.available_locales.size.should == 1
    end

    it "should return the right locale" do
      @provider.i18n.available_locales.first.should == @l
    end

  end

  describe "with 2 translations in 1 locale" do

    before :each do
      @l = Locale.create :tag => 'en-US', :name => 'English'
      ItemTranslation.create :item => @item, :locale => @l, :name => "Book", :desc => "Literature"
      ItemTranslation.create :item => @item, :locale => @l, :name => "Hook", :desc => "Tool"
      @item.reload
    end

    it "should return 1 locale" do
      @provider.i18n.available_locales.size.should == 1
    end

    it "should return the right locale" do
      @provider.i18n.available_locales.first.should == @l
    end

  end

  describe "with 3 translations in 2 locales" do

    before :each do
      @item2 = Item.create
      @l1 = Locale.create :tag => 'en-US', :name => 'English'
      @l2 = Locale.create :tag => 'de-AT', :name => 'Deutsch'
      ItemTranslation.create :item => @item,  :locale => @l1, :name => "Book",  :desc => "Literature"
      ItemTranslation.create :item => @item,  :locale => @l2, :name => "Haken", :desc => "Werkzeug"
      ItemTranslation.create :item => @item2, :locale => @l1, :name => "Hook",  :desc => "Tool"
    end

    it "should return 2 locales" do
      @provider.i18n.available_locales.size.should == 2
    end

    it "should return the right locale" do
      @provider.i18n.available_locales.size.should == 2
      @provider.i18n.available_locales.should include(@l1)
      @provider.i18n.available_locales.should include(@l2)
    end

  end

end
