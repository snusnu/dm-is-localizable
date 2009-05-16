require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "DataMapper.auto_migrate!" do

  it "should allow to automigrate the resource to be translated" do
    lambda { Item.auto_migrate! }.should_not raise_error
  end

  it "should allow to automigrate the resource where translations will be stored" do
    lambda { ItemTranslation.auto_migrate! }.should_not raise_error
  end

end
