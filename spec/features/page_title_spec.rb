require "spec_helper"

# checks for correct page titles of site pages
feature 'Checks page title' do

  # visiting pages directly 

  scenario 'when visiting homepage directly' do
    visit_homepage_direct
    expect(page).to have_title "OhanaSMC"
  end

  scenario 'when visiting results page directly' do
    visit ('/organizations?utf8=%E2%9C%93&keyword=market&location=redwood+city')
    expect(page).to have_title "Showing 7 of 7 results matching 'market' within 2 miles of 'redwood city' | OhanaSMC"
  end

  scenario 'when visiting details page directly' do
    visit ('/organizations/51d5b18ca4a4d8b01b3e4591?utf8=%E2%9C%93&keyword=food&location=san+mateo&')
    expect(page).to have_title "25th Avenue Farmers' Market | OhanaSMC"
  end

  scenario 'when visiting about page directly' do
    visit_about_page_direct
    expect(page).to have_title "About | OhanaSMC"
  end

  # visiting pages via links

  scenario 'when performing a search and visiting results page' do
    search_for_keyword_and_location("food","san mateo")
    expect(page).to have_title "Showing 9 of 9 results matching 'food' within 2 miles of 'san mateo' | OhanaSMC"
  end

  scenario 'when performing a search and visiting details page' do
    search_for_keyword_and_location("food","san mateo")
    visit_details
    expect(page).to have_title "Urban Table Certified Farmer's Market | OhanaSMC"
  end

  # visiting pages via ajax
  scenario 'when performing a search and visiting results page via ajax',
  :js=>true do
    search_for_nothing
    search_for_keyword_and_location("food","san mateo")
    expect(page).to have_title "Showing 9 of 9 results matching 'food' within 2 miles of 'san mateo' | OhanaSMC"
  end

  scenario 'when performing a search and visiting details page via ajax',
  :js=>true do
    search_for_keyword_and_location("food","san mateo")
    visit_details
    expect(page).to have_title "Urban Table Certified Farmer's Market | OhanaSMC"
  end

end