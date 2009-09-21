require 'spec_helper'

describe "all available_languages providers", :shared => true do

  describe "with no translations" do

    it "should return 0 languages" do
      @provider.available_languages.size.should == 0
    end

  end

  describe "with 1 translation in 1 language" do

    before :each do
      @l = Language.create :code => 'en-US', :name => 'English'
      @t = ItemTranslation.create :item => @item, :language => @l, :name => "Book", :desc => "Literature"
    end

    it "should return 1 language" do
      @provider.available_languages.size.should == 1
    end

    it "should return the right language" do
      @provider.available_languages.first.should == @l
    end

  end

  describe "with 2 translations in 1 language" do

    before :each do
      @l = Language.create :code => 'en-US', :name => 'English'
      @t = ItemTranslation.create :item => @item, :language => @l, :name => "Book", :desc => "Literature"
      @t = ItemTranslation.create :item => @item, :language => @l, :name => "Hook", :desc => "Tool"
      @item.reload
    end

    it "should return 1 language" do
      @provider.available_languages.size.should == 1
    end

    it "should return the right language" do
      @provider.available_languages.first.should == @l
    end

  end

  describe "with 3 translations in 2 languages" do

    before :each do
      @item2 = Item.create
      @l1 = Language.create :code => 'en-US', :name => 'English'
      @l2 = Language.create :code => 'de-AT', :name => 'Deutsch'
      ItemTranslation.create :item => @item,  :language => @l1, :name => "Book",  :desc => "Literature"
      ItemTranslation.create :item => @item,  :language => @l2, :name => "Haken", :desc => "Werkzeug"
      ItemTranslation.create :item => @item2, :language => @l1, :name => "Hook",  :desc => "Tool"
    end

    it "should return 2 language" do
      @provider.available_languages.size.should == 2
    end

    it "should return the right language" do
      @provider.available_languages.size.should == 2
      @provider.available_languages.should include(@l1)
      @provider.available_languages.should include(@l2)
    end

  end

end
