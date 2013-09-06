require 'spec_helper'

feature "market details", :js => true do

  context "when the details page is visited via search results" do
    background do
      VCR.use_cassette('market_details/search_and_visit') do
        search_from_home(:keyword => 'maceo')
        visit_details
      end
    end

    xscenario 'view details page' do
      find_link("http://www.smchealth.org")
      looks_like_market
    end

    xscenario 'return to search results via details page', :vcr do
      find_link("Result list").click
      page.find("#search-summary").
        should have_content("1 of 1 result matching 'maceo'")
    end
  end

  xscenario "when the details page is visited directly", :vcr do
    visit('/organizations/521d33a01974fcdb2b0026a9')
    looks_like_market
  end
end
