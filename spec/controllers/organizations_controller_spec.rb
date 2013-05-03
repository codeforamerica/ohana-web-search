require 'spec_helper'

describe OrganizationsController do
	
  describe "GET 'index'" do
    it "returns 200 status code" do
      organization = create(:organization) #shortcut for FactoryGirl.create
      get :index
      response.code.should eq("200")
    end
  end

end
