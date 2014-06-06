require 'spec_helper'

feature "homepage search" do

  scenario 'with keyword that returns results', :vcr do
    search_for_maceo
    looks_like_results
    expect(find_field("keyword").value).to eq("maceo")
    expect(page).not_to have_content("1 result located!")
  end

  scenario 'with keyword that returns no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    looks_like_no_results
    expect(page).not_to have_content("No results located!")
  end

    scenario "when searching for 'food stamps'", :vcr do
    search_from_home(:keyword => 'food stamps')
    expect(page).to have_content("Known federally as SNAP")
  end

  scenario "when searching for 'health care reform'", :vcr do
    search_from_home(:keyword => 'Health care reform')
    expect(page).to have_content("Millions of Californians can choose")
  end

  scenario "when searching for 'market match'", :vcr do
    search_from_home(:keyword => 'market match')
    expect(page).to have_content("an extra $5 when they spend at least $10")
  end

  scenario "when searching for 'sfmnp'", :vcr do
    search_from_home(:keyword => 'SFMNP')
    expect(page).to have_content("provides low-income seniors with coupons")
  end

  scenario "when searching for 'wic'", :vcr do
    search_from_home(:keyword => 'wic')
    expect(page).to have_content("provides assistance for low-income")
  end

  scenario "when clicking a category", :vcr do
    visit("/")
    click_link("Health Insurance")
    expect(page).to have_content("Health Insurance TeleCenter")
  end
end
