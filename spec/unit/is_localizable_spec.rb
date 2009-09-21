require 'spec_helper'

describe "is_localizable with no options" do

  before :each do
    @i = Item.create
    @l = Language.create :code => 'en', :name => 'English'
    @t = ItemTranslation.new :item => @i, :language => @l
  end

  it "should belong_to a resource" do
    @t.respond_to?(:item).should == true
    @t.item.should be_instance_of(Item)
  end

  it "should belong_to a language" do
    @t.respond_to?(:language).should == true
    @t.language.should be_instance_of(Language)
    @t.language.code.should == 'en'
    @t.language.name.should == 'English'
  end

  it "should store properties defined inside the block in the translations resource" do
    @t.respond_to?(:name).should == true
    @t.respond_to?(:desc).should == true
  end

end
