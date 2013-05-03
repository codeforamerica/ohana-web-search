require 'spec_helper'

describe OrganizationsController do
	render_views

  describe "GET 'index'" do
    it "returns 200 status code" do
      get :index, :address => ""
      response.code.should eq("200")
    end
  end

end
