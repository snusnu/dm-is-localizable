require 'spec_helper'

describe "Language" do

  describe "with valid attributes" do

    it "should be valid" do
      Language.new(:locale => "en-US", :name => "English").should be_valid
    end

    it "should store unique locale string locales" do
      Language.create(:locale => "en-US", :name => "English").should_not be_new
      Language.create(:locale => "en-US", :name => "English").should be_new
    end

  end

  describe "with incomplete attributes" do

    before :each do
      @l = Language.new
    end

    it "should require a locale" do
      @l.name = "English"
      @l.should_not be_valid
      @l.errors.size.should == 1
      @l.errors.on(:locale).should_not be_empty
    end

    it "should require a name" do
      @l.locale = "en-US"
      @l.should_not be_valid
      @l.errors.size.should == 1
      @l.errors.on(:name).should_not be_empty
    end

  end

  describe "with invalid attributes" do

    it "should not accept invalid locale strings" do
      Language.new(:locale => 'foo',     :name => "English").should_not be_valid
      Language.new(:locale => 'foo-bar', :name => "English").should_not be_valid
      Language.new(:locale => 'foo-BAR', :name => "English").should_not be_valid
      Language.new(:locale => 'FOO-bar', :name => "English").should_not be_valid
      Language.new(:locale => 'FOO-BAR', :name => "English").should_not be_valid
      Language.new(:locale => 'en-us',   :name => "English").should_not be_valid
      Language.new(:locale => 'EN-us',   :name => "English").should_not be_valid
      Language.new(:locale => 'EN-US',   :name => "English").should_not be_valid
    end

    it "should only allow unique locale string locales" do
      l1 = Language.create(:locale => 'en-US', :name => "English")
      l1.should_not be_new
      l2 = Language.create(:locale => 'en-US', :name => "English")
      l2.should be_new
      l2.errors.on(:locale).should_not be_empty
      l2.errors.size.should == 1
    end

  end

  describe "the for(value) class method" do

    before :each do
      Language.create :locale => 'en-US', :name => 'English'
      Language.create :locale => 'de-AT', :name => 'Deutsch'
    end

    describe "with nil as paramter" do

      it "should return nil" do
        Language.for(nil).should be_nil
      end

    end

    describe "with an invalid (not present) language symbol as parameter" do

      it "should return nil" do
        Language.for(:it).should be_nil
      end

    end

    describe "with a valid (present) language symbol as parameter" do

      it "should return the correct language instance" do
        Language.for(:en_US).should == Language.first(:locale => 'en-US')
      end

    end

  end

end
