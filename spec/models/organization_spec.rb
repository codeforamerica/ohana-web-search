require 'spec_helper'

describe Organization do
	it "responds to address" do
		subject.should respond_to(:address)
	end

	it "joins all address elements into one string" do
		subject.address.should == "#{subject.street_address}, #{subject.city}, #{subject.state} #{subject.zipcode}"
	end
	
end
