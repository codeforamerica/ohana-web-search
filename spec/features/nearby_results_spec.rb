feature 'Display organizations that are within 2 miles of the one being visited' do

  xscenario 'there are nearby locations' do
    organization = FactoryGirl.create(:organization)
    nearby_org = FactoryGirl.create(:nearby_org)
    search_and_visit_details
    expect(page).to have_content("Nearby")
    expect(page).to have_content("Burlingame Main")
  end

  xscenario 'there are no nearby locations' do
    organization = FactoryGirl.create(:farmers_market)
    search_for_keyword_and_location('pescadero', 'la honda, ca')
    expect(page).to have_content("1 result matching 'pescadero' within 2 miles of 'la honda, ca'")
    click_link("Pescadero Grown")
    expect(page).to have_content("8875")
    expect(page).to have_no_content("Nearby")
  end

end