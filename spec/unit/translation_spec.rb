require 'spec_helper'

describe "the remixed translation resource" do

  before :each do
    @l = Locale.create :tag => 'en-US', :name => 'English'
    @i = Item.create
    @t1 = ItemTranslation.create(:item => @i, :locale => @l)
  end

  it "should belong to a localizable resource" do
    @t1.item.should == @i
  end

  it "should belong to a locale" do
    @t1.locale.should == @l
  end

  it "should store unique locales for every resource to translate" do
    @t2 = ItemTranslation.create(:item => @i, :locale => @l)
    @t1.should_not be_new
    @t2.should     be_new
    @t2.errors.should_not be_empty
    @t2.errors.size.should == 1
  end

end
