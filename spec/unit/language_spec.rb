require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Language" do

  describe "with valid attributes" do

    it "should be valid" do
      Language.new(:code => "en-US", :name => "English").should be_valid
    end

    it "should store unique locale string codes" do
      Language.create(:code => "en-US", :name => "English").should_not be_new_record
      Language.create(:code => "en-US", :name => "English").should be_new_record
    end

  end

  describe "with incomplete attributes" do

    before :each do
      @l = Language.new
    end

    it "should require a code" do
      @l.name = "English"
      @l.should_not be_valid
      @l.errors.size.should == 1
      @l.errors.on(:code).should_not be_empty
    end

    it "should require a name" do
      @l.code = "en-US"
      @l.should_not be_valid
      @l.errors.size.should == 1
      @l.errors.on(:name).should_not be_empty
    end

  end

  describe "with invalid attributes" do

    it "should not accept invalid locale strings" do
      Language.new(:code => 'foo',     :name => "English").should_not be_valid
      Language.new(:code => 'foo-bar', :name => "English").should_not be_valid
      Language.new(:code => 'foo-BAR', :name => "English").should_not be_valid
      Language.new(:code => 'FOO-bar', :name => "English").should_not be_valid
      Language.new(:code => 'FOO-BAR', :name => "English").should_not be_valid
      Language.new(:code => 'en-us',   :name => "English").should_not be_valid
      Language.new(:code => 'EN-us',   :name => "English").should_not be_valid
      Language.new(:code => 'EN-US',   :name => "English").should_not be_valid
    end
    
    it "should only allow unique locale string codes" do
      Language.create(:code => 'en-US', :name => "English").should_not be_new_record
      Language.create(:code => 'en-US', :name => "English").should     be_new_record
    end

  end

end
