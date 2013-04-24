require 'spec_helper'

describe Organization do
	
	subject { FactoryGirl.build(:organization) }

	it { should respond_to(:address) }
	
	its(:address) { should == "#{subject.street_address}, #{subject.city}, #{subject.state} #{subject.zipcode}" }

end
