require 'spec_helper'

describe StatusController do

  describe "GET /.well-known/status" do

    context "when everything is fine", :vcr do
      it "returns success" do
        get "get_status"
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("ok")
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
        stub_request(:get, "http://ohana-api-test.herokuapp.com/api/locations/san-mateo-free-medical-clinic?api_token=#{ENV["OHANA_API_TOKEN"]}").
          with(:headers => {'Accept'=>'application/vnd.ohanapi-v1+json',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ohanakapa Ruby Gem 1.0.0',
            'X-Api-Token'=>"#{ENV["OHANA_API_TOKEN"]}"}).
          to_return(:status => 200, :body => "", :headers => {})

        stub_request(:get, "http://ohana-api-test.herokuapp.com/api/search?api_token=#{ENV["OHANA_API_TOKEN"]}&keyword=maceo").
          with(:headers => {'Accept'=>'application/vnd.ohanapi-v1+json',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ohanakapa Ruby Gem 1.0.0',
            'X-Api-Token'=>"#{ENV["OHANA_API_TOKEN"]}"}).
          to_return(:status => 200, :body => "", :headers => {})

        get "get_status"
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("API did not respond")
      end
    end
  end
end