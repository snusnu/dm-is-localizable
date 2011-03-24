require 'spec_helper'

describe "the remixed translation resource" do

  before :each do
    @l = Language.create :locale => 'en-US', :name => 'English'
    @i = Item.create
    @t1 = ItemTranslation.create(:item => @i, :language => @l)
  end

  it "should belong to a localizable resource" do
    @t1.item.should == @i
  end

  it "should belong to a language" do
    @t1.language.should == @l
  end

  it "should store unique languages for every resource to translate" do
    @t2 = ItemTranslation.create(:item => @i, :language => @l)
    @t1.should_not be_new
    @t2.should     be_new
    @t2.errors.should_not be_empty
    @t2.errors.size.should == 1
  end

end
