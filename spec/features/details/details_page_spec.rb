require 'spec_helper'

feature "details page", :js => true do

  context "when the details page is visited via search results" do
    background do
      VCR.use_cassette('details_page/search_and_visit') do
        search_from_home(:keyword => 'maceo')
        visit_details
      end
    end

    scenario 'view details page' do
      find_link("http://www.smchealth.org")
      looks_like_details
    end

    scenario 'return to search results via details page', :vcr do
      find_link("Result list").click
      page.find("#search-summary").
        should have_content("1 of 1 result matching 'maceo'")
    end
  end

  scenario "when the details page is visited directly", :vcr do
    visit('/organizations/51de0b9fa4a4d8b01b3e459d')
    looks_like_details
  end
end
