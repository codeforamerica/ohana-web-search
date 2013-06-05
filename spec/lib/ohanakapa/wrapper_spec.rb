require 'spec_helper'
describe Ohanakapa::Wrapper do
 
  describe "default attributes" do
 
    it "should include httparty methods" do
      Ohanakapa::Wrapper.should include(HTTParty)
    end
 
    it "should have the base url set to the Ohana API endpoint" do
      Ohanakapa::Wrapper.base_uri.should eq('http://ohanapi.herokuapp.com/api')
    end
 
  end
 
end