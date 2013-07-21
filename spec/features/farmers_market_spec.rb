require 'spec_helper'

feature 'Visitor views the details page of a farmers market' do

  scenario 'market accepts SNAP and sells cheese' do
    search_for_keyword_and_location('pescadero', 'la honda, ca')
    click_link("Pescadero Grown")
    expect(page).to have_content("8875 La Honda Road La Honda, CA 94020")
    expect(page).to have_content("SFMNP Senior Farmers' Market Nutrition")
    expect(page).to have_content("Supplemental Nutrition Assistance Program")
    expect(page).to have_content("Women, Infants, and Children provides")
    expect(page).to have_content("Products sold: Cheese")
    expect(page).to have_content("May - November Tuesday 3:00 PM to 7:00 PM")

    page.should have_link("http://Www.pescaderogrown.org",
      :href => "http://Www.pescaderogrown.org")
  end

  scenario 'market participates in Market match' do
    search_for_keyword('san mateo farmers')
    click_link("San Mateo Farmers' Market")
    expect(page).to have_content("This market participates in Market Match")
  end
end