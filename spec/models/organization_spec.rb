require 'spec_helper'

describe Organization do

	subject { build(:full_org) }

	it { should be_valid }

	it { should respond_to(:address) }
	its(:address) { should == "#{subject.street_address}, #{subject.city}, #{subject.state} #{subject.zipcode}" }

	it { should respond_to(:market_match?) }
  its(:market_match?) { should be_true }

  it { should respond_to(:mapURL) }
 	its(:mapURL) { should == "http://maps.googleapis.com/maps/api/staticmap?center=#{subject.latitude},#{subject.longitude}&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C#{subject.latitude},#{subject.longitude}&sensor=false"
 }

  context "does not participate in market match" do
	  subject { build(:org_without_market_match) }
	  its(:market_match?) { should be_false }
	end

	describe "invalidations" do
		context "without a name" do
	  	subject { build(:organization, name: nil)} 
	  	it { should_not be_valid }
		end

		context "without a street address" do
	  	subject { build(:organization, street_address: nil) }
	  	it { should_not be_valid }
		end

		context "without a city" do
	  	subject { build(:organization, city: nil) }
	  	it { should_not be_valid }
		end

		context "without a state" do
	  	subject { build(:organization, state: nil) }
	  	it { should_not be_valid }
		end

		context "without a zipcode" do
	  	subject { build(:organization, zipcode: nil) }
	  	it { should_not be_valid }
		end

		context "with a zipcode less than 5 characters" do
	  	subject { build(:organization, zipcode: "1234") }
	  	it { should_not be_valid }
		end

		context "with a zipcode that has 6 consecutive digits" do
	  	subject { build(:organization, zipcode: "123456") }
	  	it { should_not be_valid }
		end

		context "with a zipcode that has too few digits after the dash" do
	  	subject { build(:organization, zipcode: "12345-689") }
	  	it { should_not be_valid }
		end

		context "with a zipcode greater than 10 characters" do
	  	subject { build(:organization, zipcode: "90210-90210") }
	  	it { should_not be_valid }
		end
	end
end
