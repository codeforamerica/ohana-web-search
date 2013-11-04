require 'spec_helper'

feature "results page search", :js=>true do

  background do
    search_from_home
  end

  scenario 'with keyword that returns results', :vcr do
    search_for_test_case
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
    within("#location-options") do
      find(".current-option").should have_content('94060')
    end
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

  scenario 'when clicking organization link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    delay
    page.first("a", text: "St. Vincent de Paul Society").click
    expect(page).to_not have_content("Shelter Network")
    expect(page).to have_content("San Mateo Homeless Help Center")
  end

end