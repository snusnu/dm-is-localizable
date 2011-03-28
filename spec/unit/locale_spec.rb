require 'spec_helper'

describe "Locale" do

  describe "with valid attributes" do

    it "should be valid" do
      Locale.new(:locale => "en-US", :name => "English").should be_valid
    end

    it "should store unique locale string locales" do
      Locale.create(:locale => "en-US", :name => "English").should_not be_new
      Locale.create(:locale => "en-US", :name => "English").should be_new
    end

  end

  describe "with incomplete attributes" do

    before :each do
      @l = Locale.new
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
      Locale.new(:locale => 'foo',     :name => "English").should_not be_valid
      Locale.new(:locale => 'foo-bar', :name => "English").should_not be_valid
      Locale.new(:locale => 'foo-BAR', :name => "English").should_not be_valid
      Locale.new(:locale => 'FOO-bar', :name => "English").should_not be_valid
      Locale.new(:locale => 'FOO-BAR', :name => "English").should_not be_valid
      Locale.new(:locale => 'en-us',   :name => "English").should_not be_valid
      Locale.new(:locale => 'EN-us',   :name => "English").should_not be_valid
      Locale.new(:locale => 'EN-US',   :name => "English").should_not be_valid
    end

    it "should only allow unique locale string locales" do
      l1 = Locale.create(:locale => 'en-US', :name => "English")
      l1.should_not be_new
      l2 = Locale.create(:locale => 'en-US', :name => "English")
      l2.should be_new
      l2.errors.on(:locale).should_not be_empty
      l2.errors.size.should == 1
    end

  end

  describe "the for(value) class method" do

    before :each do
      Locale.create :locale => 'en-US', :name => 'English'
      Locale.create :locale => 'de-AT', :name => 'Deutsch'
    end

    describe "with nil as paramter" do

      it "should return nil" do
        Locale.for(nil).should be_nil
      end

    end

    describe "with an invalid (not present) language symbol as parameter" do

      it "should return nil" do
        Locale.for(:it).should be_nil
      end

    end

    describe "with a valid (present) language symbol as parameter" do

      it "should return the correct language instance" do
        Locale.for(:en_US).should == Locale.first(:locale => 'en-US')
      end

    end

  end

end
