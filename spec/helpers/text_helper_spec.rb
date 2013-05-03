require 'spec_helper'
describe TextHelper do

	it { pluralize(1, "result").should == "1 result" }
	it { pluralize(0, "result").should == "0 results" }
	it { pluralize(5, "mile").should == "5 miles" }
end