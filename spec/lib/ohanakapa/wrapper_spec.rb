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

	describe "GET organizations" do

 		let(:wrapper) { Ohanakapa::Wrapper.new }

 		it "must have an organizations method" do
			wrapper.should respond_to(:organizations)
		end

		it "must parse the API response from JSON to Hash" do
			wrapper.organizations.should be_an_instance_of(Hash)
		end

 	end

	describe "GET search" do

	 	let(:wrapper) { Ohanakapa::Wrapper.new }

	 	it "must have a search method" do
			wrapper.should respond_to(:search)
		end

		it "must parse the API response from JSON to Hash with 'food' search" do
			wrapper.search('food').should be_an_instance_of(Hash)
		end

  end
 
end