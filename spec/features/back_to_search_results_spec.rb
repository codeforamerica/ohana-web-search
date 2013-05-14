feature 'Visitor goes back to search results' do

  scenario 'from the details page of one of the original results' do
    organization = FactoryGirl.create(:organization)
    search_and_visit_details
    find("#detail-screen").find("nav").find("a").click
    expect(page).to have_content("1 result matching 'library'")
  end

  scenario 'from the details page of one of the nearby results' do
    organization = FactoryGirl.create(:organization)
    nearby_org = FactoryGirl.create(:nearby_org)
    search_and_visit_details
    visit_nearby_details
    find("#detail-screen").find("nav").find("a").click
    expect(page).to have_content("2 results matching 'library'")
  end

end