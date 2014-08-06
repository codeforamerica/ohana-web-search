require 'spec_helper'

feature "results page search", :vcr do

  background do
    visit '/organizations'
  end

  scenario 'with keyword that returns results' do
    search_for_maceo
    expect(find_field("keyword").value).to eq("maceo")
    looks_like_results
  end

  scenario 'with keyword that returns no results' do
    search(:keyword => 'asdfg')
    looks_like_no_results
    expect(find_field("keyword").value).to eq("asdfg")
  end

  scenario 'with location that returns results', :js do
    search(:keyword => "", :location => '94403')
    within("#location-options") do
      expect(find(".current-option")).to have_content('94403')
    end
    expect(page).to have_content("San Mateo Free Medical Clinic")
  end

  scenario 'with location that returns no results', :js do
    # The search from the background action leaves the keyword field
    # populated, so to do a location-only search, we have to clear it first.
    search(:keyword => "", :location => 'asdfg')
    looks_like_no_results
  end

  scenario 'with keyword and location that returns results', :js do
    search(:keyword => "clinic", :location => '94403')
    expect(page).to have_content("San Mateo Free Medical Clinic")
  end

  scenario 'with keyword and location that returns no results', :js do
    search(:keyword => "sdaff", :location => '94403')
    looks_like_no_results
  end

  scenario "when click Kind link" do
    visit('/organizations?keyword=soccer')
    page.first("a", text: "Other").click
    expect(find("#list-view")).not_to have_content("Sports")
  end

  context 'when search contains invalid parameters' do
    it 'displays a helpful error message' do
      visit('/organizations?location=94403&radius=foo')
      expect(page).
        to have_content('That search was improperly formatted.')
    end
  end

  context 'when a search parameter has no value' do
    it 'is not included in the page title' do
      visit('/organizations?location=94403&keyword=')
      expect(page).
        to have_title('Search results for: location: 94403 | SMC-Connect')
    end
  end

  context 'when multiple search parameters have values' do
    it 'they are all included in the page title' do
      visit('/organizations?location=94403&keyword=foo')
      expect(page).
        to have_title('location: 94403, keyword: foo | SMC-Connect')
    end
  end
end
