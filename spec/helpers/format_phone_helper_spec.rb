require 'spec_helper'
describe FormatPhoneHelper do
	
	it { format_phone("000.000.0000").should == "(000) 000-0000" }
	
end