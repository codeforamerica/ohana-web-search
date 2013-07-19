require "spec_helper"

feature 'Checks page title' do

  scenario 'visits homepage directly' do
    visit ('/')
    expect(page).to have_title "OhanaSMC"
  end

  scenario 'visits results page directly' do
    visit ('/organizations?utf8=%E2%9C%93&keyword=market&location=redwood+city')
    expect(page).to have_title "Showing 7 of 7 results matching 'market' within 2 miles of 'redwood city' | OhanaSMC"
  end

  scenario 'visits details page directly' do
    visit ('/organizations/51d5b18ca4a4d8b01b3e4591?utf8=%E2%9C%93&keyword=food&location=san+mateo&')
    expect(page).to have_title "25th Avenue Farmers' Market | OhanaSMC"
  end

  scenario 'performs a search and visits results page' do
    search_for_keyword_and_location("food","san mateo")
    expect(page).to have_title "Showing 9 of 9 results matching 'food' within 2 miles of 'san mateo' | OhanaSMC"
  end

  scenario 'performs a search and visits details page' do
    search_for_keyword_and_location("food","san mateo")
    visit_details
    expect(page).to have_title "Urban Table Certified Farmer's Market | OhanaSMC"
  end

end