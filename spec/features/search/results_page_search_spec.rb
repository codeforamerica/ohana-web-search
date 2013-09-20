require 'spec_helper'

feature "results page search" do

  background do
    VCR.use_cassette('homepage_search/with_keyword_that_returns_results') do
      search_from_home(:keyword => 'maceo')
    end
  end

  scenario 'with keyword that returns results', :vcr do
    search(:keyword => 'maceo')
    find_field("keyword").value.should == "maceo"
    looks_like_results
  end

  scenario 'with keyword that returns no results', :vcr do
    search(:keyword => 'asdfg')
    looks_like_no_results
    find_field("keyword").value.should == "asdfg"
  end

  scenario 'with location that returns results', :vcr do
    # The search from the background action leaves the keyword field
    # populated, so to do a location-only search, we have to clear it first.
    search(:keyword => "", :location => '94060')
    find_field("location").value.should == "94060"
    looks_like_puente
  end

  scenario 'with location that returns no results', :vcr do
    # The search from the background action leaves the keyword field
    # populated, so to do a location-only search, we have to clear it first.
    search(:keyword => "", :location => 'asdfg')
    looks_like_no_results
  end

  scenario 'with keyword and location that returns results', :vcr do
    search(:keyword => "puente", :location => '94060')
    looks_like_puente
  end

  scenario 'with keyword and location that returns no results', :vcr do
    search(:keyword => "sdaff", :location => '94403')
    looks_like_no_results
  end

  scenario 'with language that returns less results', :vcr do
    search_by_language("Tagalog (Filipino)")
    expect(page).to have_content("1-30 of 112 results")
  end

end