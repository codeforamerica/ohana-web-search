require 'spec_helper'

feature "results page search" do

  background do
    VCR.use_cassette('results/keyword_search_that_returns_results') do
      search_from_home(:keyword => 'maceo')
    end
  end

  scenario 'with keyword-only search that returns results' do
    VCR.use_cassette('homepage/keyword_search_that_returns_results') do
      search(:keyword => 'maceo')
      find_field("keyword").value.should == "maceo"
      looks_like_results
    end
  end

  scenario 'with keyword-only search that returns no results' do
    VCR.use_cassette('homepage/keyword_search_that_returns_no_results') do
      search(:keyword => 'asdfg')
      looks_like_no_results
      find_field("keyword").value.should == "asdfg"
    end
  end

  scenario 'with location-only search that returns results' do
    VCR.use_cassette('homepage/location_search_that_returns_results',
      :erb => { :name => "SanMaceo Example Agency" }) do
      # The search from the background action leaves the keyword field
      # populated, so to do a location-only search, we have to clear it first.
      search(:keyword => "", :location => '94060')
      find_field("location").value.should == "94060"
      looks_like_results
    end
  end

  scenario 'with location-only search that returns no results' do
    VCR.use_cassette('homepage/location_search_that_returns_no_results') do
      # The search from the background action leaves the keyword field
      # populated, so to do a location-only search, we have to clear it first.
      search(:keyword => "", :location => 'asdfg')
      looks_like_no_results
    end
  end

  scenario 'with keyword-location search that returns results' do
    VCR.use_cassette('homepage/key_loc_search_that_returns_results',
      :erb => { :name => "SanMaceo Example Agency" }) do
      search(:keyword => "puente", :location => '94060')
      looks_like_results
    end
  end

  scenario 'with keyword-location search that returns no results' do
    VCR.use_cassette('homepage/key_loc_search_that_returns_no_results') do
      search(:keyword => "sdaff", :location => '94403')
      looks_like_no_results
    end
  end
end