require 'spec_helper'

describe Organization do

	subject { build(:full_org) }

	it { should be_valid }

	it { should respond_to(:formatted_address) }
	its(:formatted_address) { should == "#{superscript_ordinals(subject.street_address)}, #{subject.city}, #{subject.state} #{subject.zipcode}" }

	it { should respond_to(:market_match?) }
  its(:market_match?) { should be_true }

  it { should respond_to(:mapURL) }
 	its(:mapURL) { should == "http://maps.googleapis.com/maps/api/staticmap?center=#{subject.latitude},#{subject.longitude}&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C#{subject.latitude},#{subject.longitude}&sensor=false"
 }

  context "does not participate in market match" do
	  subject { build(:org_without_market_match) }
	  its(:market_match?) { should be_false }
	end

	# describe "zip code validations" do
	# 	context "address entry with more than 4 zeros" do
	# 		Organization.query_valid?("0000f").should == false
	# 	end

	# 	context "address entry with less than 5 digits" do
	# 		Organization.query_valid?("123").should == false
	# 	end

	# 	context "address entry with more than 5 digits" do
	# 		Organization.query_valid?("123456").should == false
	# 	end

	# 	context "address entry with 5 digits but not a real zip code" do
	# 		Organization.query_valid?("11111").should == false
	# 	end

	# 	# context "address entry with valid 5-digit zip code" do
	# 	# 	Organization.query_valid?("94403").should == true
	# 	# end
	# end

	describe "invalidations" do
		context "without a name" do
	  	subject { build(:organization, name: nil)} 
	  	it { should_not be_valid }
		end

		# context "without a street address" do
	 #  	subject { build(:organization, street_address: nil) }
	 #  	it { should_not be_valid }
		# end

		# context "without a city" do
	 #  	subject { build(:organization, city: nil) }
	 #  	it { should_not be_valid }
		# end

		# context "without a state" do
	 #  	subject { build(:organization, state: nil) }
	 #  	it { should_not be_valid }
		# end

		# context "without a zipcode" do
	 #  	subject { build(:organization, zipcode: nil) }
	 #  	it { should_not be_valid }
		# end

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

		context "with a non-US phone" do
	  	subject { build(:organization, phone: "90210-90210") }
	  	it { should_not be_valid }
		end

		context "with US phone containing dots" do
	  	subject { build(:organization, phone: "123.456.7890") }
	  	it { should be_valid }
		end

		context "with URL containing 3 slashes" do
	  	subject { build(:organization, urls: ["http:///codeforamerica.org"]) }
	  	it { should_not be_valid }
		end

		context "with URL missing a period" do
	  	subject { build(:organization, urls: ["http://codeforamericaorg"]) }
	  	it { should_not be_valid }
		end

		context "URL with wwww" do
	  	subject { build(:organization, urls: ["http://wwww.codeforamerica.org"]) }
	  	it { should be_valid }
		end

		context "non-US URL" do
	  	subject { build(:organization, urls: ["http://www.colouredlines.com.au"]) }
	  	it { should be_valid }
		end

		context "email without period" do
	  	subject { build(:organization, emails: ["moncef@blahcom"]) }
	  	it { should_not be_valid }
		end

		context "email without @" do
	  	subject { build(:organization, emails: ["moncef.blahcom"]) }
	  	it { should_not be_valid }
		end
	end
end
