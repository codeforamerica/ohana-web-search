require 'spec_helper'

feature "homepage search", :js=>true do

  scenario 'with keyword that returns results', :vcr do
    search_for_maceo
    looks_like_results
    find_field("keyword").value.should == "maceo"
    page.should_not have_content("1 result located!")
  end

  scenario 'with keyword that returns no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    looks_like_no_results
    page.should_not have_content("No results located!")
  end

    scenario "when searching for 'food stamps'", :vcr do
    search_from_home(:keyword => 'food stamps')
    page.should have_content("Known federally as SNAP")
  end

  scenario "when searching for 'health care reform'", :vcr do
    search_from_home(:keyword => 'Health care reform')
    page.should have_content("Millions of Californians can choose")
  end

  scenario "when searching for 'market match'", :vcr do
    search_from_home(:keyword => 'market match')
    page.should have_content("an extra $5 when they spend at least $10")
  end

  scenario "when searching for 'sfmnp'", :vcr do
    search_from_home(:keyword => 'SFMNP')
    page.should have_content("provides low-income seniors with coupons")
  end

  scenario "when searching for 'wic'", :vcr do
    search_from_home(:keyword => 'wic')
    page.should have_content("provides assistance for low-income")
  end

  scenario "when clicking a category", :vcr do
    visit("/")
    click_link("Health Insurance")
    page.should have_content("A project of the Tides Center")
  end

  xscenario "when result has keyword matching top-level category", :vcr do
    visit("/")
    click_link("Market Match")
    page.should have_link("Food")
  end

  # location is no longer displayed on homepage. Leaving this in case it's re-added.
  xscenario 'with location that returns results', :vcr do
    search_from_home(:location => '94060')
    looks_like_puente
    find_field("location").value.should == "94060"
    page.should_not have_content("1 result located!")
  end

  xscenario 'with location that returns no results', :vcr do
    search_from_home(:location => 'asdfg')
    looks_like_no_results
    page.should_not have_content("No results located!")
  end

  xscenario 'with keyword and location that returns results', :vcr do
    search_from_home(:keyword => "puente", :location => '94060')
    looks_like_puente
    find_field("location").value.should == "94060"
    page.should_not have_content("1 result located!")
  end

  xscenario 'with keyword and location that returns no results', :vcr do
    search_from_home(:keyword => "sdaff", :location => '94403')
    looks_like_no_results
    page.should_not have_content("No results located!")
  end

  scenario "when click Kind link", :vcr do
    visit('/organizations?keyword=soccer')
    page.first("a", text: "Other").click
    find("#list-view").should_not have_content("Sports")
    page.should have_content("557 results")
  end

end