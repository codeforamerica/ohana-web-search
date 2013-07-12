require 'spec_helper'
require 'json'
require 'ohanakapa'

describe DetailFormatHelper do

  before(:each) do
    @org = JSON.parse(File.read("spec/fixtures/organization.json"))

    @org_empty_address = JSON.parse('{"street_address":"","city":"","state":"","zipcode":""}')
    @org_street_only = JSON.parse('{"street_address":"Angel Island State Park","city":"","state":"","zipcode":""}')
    @org_city_only = JSON.parse('{"street_address":"","city":"San Mateo","state":"","zipcode":""}')
    @org_state_only = JSON.parse('{"street_address":"","city":"","state":"CA","zipcode":""}')
    @org_zipcode_only = JSON.parse('{"street_address":"","city":"","state":"","zipcode":"00000"}')
  end

  context '#has_address' do
    
    it 'should be false when no address fields are present' do
      helper.has_address?(@org_empty_address).should == false
    end

    it 'should be true when any address fields are present' do
      helper.has_address?(@org).should == true
      helper.has_address?(@org_street_only).should == true
      helper.has_address?(@org_city_only).should == true
      helper.has_address?(@org_state_only).should == true
      helper.has_address?(@org_zipcode_only).should == true
    end

  end

  context '#format_address' do

    it 'should be false when no address fields are present' do
      helper.has_address?(@org_empty_address).should == false
    end

  end

  context '#format_phone' do
    it 'formats an undelimited phone number' do
      helper.format_phone("0000000000").should == "(000) 000-0000"
    end

    it 'formats a dot separated phone number' do
      helper.format_phone("000.000.0000").should == "(000) 000-0000"
    end

    it 'formats a space separated phone number' do
      helper.format_phone("000 000 0000").should == "(000) 000-0000"
    end

    it 'ignores a number that is greater than 10 digits' do
      helper.format_phone("123 456 78900").should == "123 456 78900"
    end

    it 'ignores a number that is less than 10 digits' do
      helper.format_phone("123 456 789").should == "123 456 789"
    end
  end

end