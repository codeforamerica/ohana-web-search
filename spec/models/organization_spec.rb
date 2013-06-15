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

  describe "invalidations" do
    context "without a name" do
      subject { build(:organization, name: nil)}
      it { should_not be_valid }
    end
  end
end
