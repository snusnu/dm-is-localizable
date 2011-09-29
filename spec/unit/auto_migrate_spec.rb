require 'spec_helper'

describe "DataMapper.auto_migrate!" do

  it "should not raise errors" do
    lambda { DataMapper.finalize.auto_migrate! }.should_not raise_error
  end

end
