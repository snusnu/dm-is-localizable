require 'spec_helper'

describe "is_localizable with no options" do

  before :each do
    @i = Item.create
    @l = Locale.create :tag => 'en', :name => 'English'
    @t = ItemTranslation.new :item => @i, :locale => @l
  end

  it "should belong_to a resource" do
    @t.respond_to?(:item).should == true
    @t.item.should be_instance_of(Item)
  end

  it "should belong_to a locale" do
    @t.respond_to?(:locale).should == true
    @t.locale.should be_instance_of(Locale)
    @t.locale.tag.should == 'en'
    @t.locale.name.should == 'English'
  end

  it "should store properties defined inside the block in the translations resource" do
    @t.respond_to?(:name).should == true
    @t.respond_to?(:desc).should == true
  end

end
