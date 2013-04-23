require 'spec_helper'

describe Organization do
  before :each do
    @org = Organization.new(:name => "EHP", :street_address => "1415 Pulgas Ave", :city => "East Palo Alto",
    												:state => "CA", :zipcode => "94103", :phone => "350-657-9034")
  end
	
	it "joins all address elements into one string" do
		@org.address.should == "#{@org.street_address}, #{@org.city}, #{@org.state} #{@org.zipcode}"
	end
	
end
