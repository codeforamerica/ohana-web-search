require 'spec_helper'

feature 'map', :js=>true do

  context 'present', :vcr do
    before(:each) { visit('/organizations') }

    it "on results list" do
      expect(page).to have_selector("#map-view")
    end

    it "on details view" do
      visit_details
      expect(page).to have_selector("#detail-map-view")
    end

  end

  context 'not present', :vcr do
    before(:each) { search_from_home({:keyword=>'alcohol and drug helpline'}) }

    it "on results list" do
      expect(page).to_not have_selector("#map-view")
    end

    xit "on details view" do
      visit_details
      expect(page).to_not have_selector("#detail-map-view")
    end

  end

end