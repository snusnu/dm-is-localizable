require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "the remixed translation resource" do

  it "should store unique languages for every resource to translate" do
    l = Language.create :code => 'en-US', :name => 'English'
    i = Item.create
    t1 = ItemTranslation.create(:item => i, :language => l)
    t1.should_not be_new_record
    t2 = ItemTranslation.create(:item => i, :language => l)
    t2.should     be_new_record
    t2.errors.should_not be_empty
    t2.errors.size.should == 1
  end

end
