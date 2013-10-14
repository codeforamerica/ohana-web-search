require 'spec_helper'

describe StatusController do

  describe "GET /.well-known/status" do

    context "when everything is fine", :vcr do
      it "returns success" do
        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "ok"
      end
    end

    context "when API does not return results" do
      before do
        VCR.turn_off!
      end

      after do
        VCR.turn_on!
      end

      it "returns API failure error" do
        stub_request(:get, "http://ohanapi.herokuapp.com/api/locations/downtown-palo-alto-food-closet?api_token=#{ENV["OHANA_API_TOKEN"]}").
          with(:headers => {'Accept'=>'application/vnd.ohanapi-v1+json',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ohanakapa Ruby Gem 1.0.0',
            'X-Api-Token'=>"#{ENV["OHANA_API_TOKEN"]}"}).
          to_return(:status => 200, :body => "", :headers => {})

        stub_request(:get, "http://ohanapi.herokuapp.com/api/search?api_token=#{ENV["OHANA_API_TOKEN"]}&org_name=InnVision").
          with(:headers => {'Accept'=>'application/vnd.ohanapi-v1+json',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ohanakapa Ruby Gem 1.0.0',
            'X-Api-Token'=>"#{ENV["OHANA_API_TOKEN"]}"}).
          to_return(:status => 200, :body => "", :headers => {})

        get "get_status"
        body = JSON.parse(response.body)
        body["status"].should == "API did not respond"
      end
    end
  end
end