require 'spec_helper'

feature "results page search" do

  background do
    search_from_home
  end

  scenario 'with keyword that returns results', :vcr do
    search_for_maceo
    expect(find_field("keyword").value).to eq("maceo")
    looks_like_results
  end

  scenario 'with keyword that returns no results', :vcr do
    search(:keyword => 'asdfg')
    looks_like_no_results
    expect(find_field("keyword").value).to eq("asdfg")
  end

  scenario 'with location that returns results', :js, :vcr do
    search(:keyword => "", :location => '94403')
    within("#location-options") do
      expect(find(".current-option")).to have_content('94403')
    end
    expect(page).to have_content("San Mateo Free Medical Clinic")
  end

  scenario 'with location that returns no results', :js, :vcr do
    # The search from the background action leaves the keyword field
    # populated, so to do a location-only search, we have to clear it first.
    search(:keyword => "", :location => 'asdfg')
    looks_like_no_results
  end

  scenario 'with keyword and location that returns results', :js, :vcr do
    search(:keyword => "clinic", :location => '94403')
    expect(page).to have_content("San Mateo Free Medical Clinic")
  end

  scenario 'with keyword and location that returns no results', :js, :vcr do
    search(:keyword => "sdaff", :location => '94403')
    looks_like_no_results
  end

  scenario "when click Kind link", :vcr do
    visit('/organizations?keyword=soccer')
    page.first("a", text: "Other").click
    expect(find("#list-view")).not_to have_content("Sports")
  end
end
