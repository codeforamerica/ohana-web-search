require 'spec_helper'

describe OrganizationsController do

  describe "GET 'index'" do
    it "returns 200 status code" do
      VCR.use_cassette('all_results') do
        get :index
        response.code.should eq("200")
      end
    end
  end

end
