require 'spec_helper'

feature "details page", :js => true do

  context "when the details page is visited via search results" do
    background do
      VCR.use_cassette('homepage/search_and_visit') do
        search_from_home(:keyword => 'maceo')
        visit_details
      end
    end

    scenario 'view details page via the search results page' do
      find_link("http://www.smchealth.org")
      looks_like_details
    end

    scenario 'return to search results via details page' do
      VCR.use_cassette('details/return_to_results') do
        find_link("Return to results").click
        page.find("#search-summary").
          should have_content("Showing 1 of 1 result matching 'maceo'")
      end
    end
  end

  scenario "when the details page is visited directly" do
    VCR.use_cassette('details/direct_visit') do
      visit('/organizations/51de0b9fa4a4d8b01b3e459d')
      looks_like_details
    end
  end
end
