require 'spec_helper'


describe Organization do

  subject { build(:full_org) }

  it { should be_valid }

  it { should respond_to(:address) }
  its(:address) { should == "#{subject.street_address}, #{subject.city}, #{subject.state} #{subject.zipcode}" }

  it { should respond_to(:market_match?) }
  its(:market_match?) { should be_true }

	it { should respond_to(:mapURL) }
	its(:mapURL) { should == "http://maps.googleapis.com/maps/api/staticmap?center=#{subject.coordinates[1]},#{subject.coordinates[0]}&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C#{subject.coordinates[1]},#{subject.coordinates[0]}&sensor=false"
	}

  context "does not participate in market match" do
	  subject { build(:org_without_market_match) }
	  its(:market_match?) { should be_false }
	end

	context "communicates with Ohana API" do

		it "returns organization details based on an id" do
      query = Organization::get("51a9fd0328217f89770001b2")
      query.content["_id"].should eq("51a9fd0328217f89770001b2")
    end

		it "returns all organizations" do
      query = Organization::query
      query.content.first["_id"].should eq("51a9fd0028217f8977000002")
    end

		it "searches for keyword 'market'" do
      query = Organization::query({:keyword=>"market"})
      query.content.length.should eq(22)
      query.content.first["_id"].should eq("51a9fd0028217f8977000023")
    end

    it "searches for keyword 'park'" do
      query = Organization::query({:keyword=>"park"})
      query.content.length.should eq(30)
      query.content.first["_id"].should eq("51a9fd0028217f8977000014")
    end

	end

=begin
# move to the Ohana API
	describe "invalidations" do
		context "without a name" do
	  	subject { build(:organization, name: nil)} 
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

		context "with a 5 + 4 zipcode" do
	  	subject { build(:organization, zipcode: "90210-1234") }
	  	it { should be_valid }
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
	  	it { should be_valid }
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

		context "URL without http://" do
	  	subject { build(:organization, urls: ["www.monfresh.com"]) }
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

		context "email with 3 characters before the @" do
	  	subject { build(:organization, emails: ["abc@foo.com", "def@abc.com"]) }
	  	it { should be_valid }
		end
	end
=end

end
