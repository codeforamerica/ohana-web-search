require 'spec_helper'

feature 'Visitor uses the back or forward button', :js => true do

  background do
    VCR.use_cassette('homepage_search/with keyword_that_returns_results') do
      search_from_home(:keyword => 'maceo')
      page.find("#search-summary")
    end
  end

  scenario 'back button from search results to homepage', :vcr do
    go_back
    looks_like_homepage_as_user_sees_it
  end

  scenario 'forward button from homepage to results', :vcr do
    go_back
    page.find("#search-container")
    go_forward
    page.find("#search-summary").
      should have_content("1 of 1 result matching 'maceo'")
    looks_like_results
  end

  scenario 'back to homepage after 2 queries', :vcr do
    search(:keyword => 'maceo')
    go_back
    go_back
    page.find("#search-container")
    looks_like_homepage_as_user_sees_it
  end

  scenario 'back to results from details, then forward to details', :vcr do
    visit_details
    find_link("http://www.smchealth.org")
    go_back
    page.find("#search-summary").
      should have_content("1 of 1 result matching 'maceo'")
    go_forward
    find_link("http://www.smchealth.org")
    looks_like_details
  end
end