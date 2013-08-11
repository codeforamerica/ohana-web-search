require 'spec_helper'

feature "homepage search", :js => true do

  scenario 'with keyword-only search that returns results' do
    VCR.use_cassette('homepage/keyword_search_that_returns_results') do
      search_from_home(:keyword => 'maceo')
      looks_like_results
      find_field("keyword").value.should == "maceo"
      expect(page).to have_content("1 result located!")
    end
  end

  scenario 'with keyword-only search that returns no results' do
    VCR.use_cassette('homepage/keyword_search_that_returns_no_results') do
      search_from_home(:keyword => 'asdfg')
      looks_like_no_results
      expect(page).to have_content("No results located!")
    end
  end

  scenario 'with location-only search that returns results' do
    VCR.use_cassette('homepage/location_search_that_returns_results') do
      search_from_home(:location => '94060')
      looks_like_results
      find_field("location").value.should == "94060"
      expect(page).to have_content("1 result located!")
    end
  end

  scenario 'with location-only search that returns no results' do
    VCR.use_cassette('homepage/location_search_that_returns_no_results') do
      search_from_home(:location => 'asdfg')
    end
    looks_like_no_results
    expect(page).to have_content("No results located!")
  end

  scenario 'with keyword-location search that returns results' do
    VCR.use_cassette('homepage/key_loc_search_that_returns_results') do
      search_from_home(:keyword => "puente", :location => '94060')
      looks_like_results
      find_field("location").value.should == "94060"
      expect(page).to have_content("1 result located!")
    end
  end

  scenario 'with keyword-location search that returns no results' do
    VCR.use_cassette('homepage/key_loc_search_that_returns_no_results') do
      search_from_home(:keyword => "sdaff", :location => '94403')
      looks_like_no_results
      expect(page).to have_content("No results located!")
    end
  end

end