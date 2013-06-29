feature 'Visitor goes back to search results' do

  scenario 'from the details page of one of the original results' do
    search_and_visit_details
    find("#detail-screen").find("nav").find("a").click
    expect(page).to have_content("Showing 2 of 2 results matching 'library' within 2 miles of '94010'")
  end

  xscenario 'from the details page of one of the nearby results' do
    organization = FactoryGirl.create(:organization)
    nearby_org = FactoryGirl.create(:nearby_org)
    search_and_visit_details
    visit_nearby_details
    find("#detail-screen").find("nav").find("a").click
    expect(page).to have_content("2 results matching 'library'")
  end

end