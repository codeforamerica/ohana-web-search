require 'spec_helper'

feature 'search results map' do

  context 'results have entries that have coordinates', :vcr do
    it "displays a results list map" do
      visit('/organizations/')
      expect(page).to have_selector("#map-view")
    end
  end

  context 'none of the results have coordinates', :vcr do
    it "does not display a results list map" do
      search_for_location_without_address
      expect(page).not_to have_selector("#map-view")
    end
  end
end
