require "spec_helper"

# checks for correct page titles of site pages
feature 'Checks page title' do

  # visiting pages directly 

  scenario 'when visiting homepage directly' do
    visit ('/')
    looks_like_homepage
  end

  scenario 'when visiting results page directly' do
    visit ('/organizations?utf8=%E2%9C%93&keyword=market&location=redwood+city')
    looks_like_results
    expect(page).to have_title "Showing 7 of 7 results matching 'market' within 2 miles of 'redwood city' | OhanaSMC"
  end

  scenario 'when visiting details page directly' do
    visit ('/organizations/51d5b18ca4a4d8b01b3e4591?utf8=%E2%9C%93&keyword=food&location=san+mateo&')
    looks_like_details("25th Avenue Farmers' Market")
  end

  scenario 'when visiting about page directly' do
    visit ('/about')
    looks_like_about
  end

  # visiting pages via links

  scenario 'when performing a search and visiting results page' do
    search(:path=>'/',:keyword=>'food',:location=>'san mateo')
    looks_like_results
    expect(page).to have_title "Showing 9 of 9 results matching 'food' within 2 miles of 'san mateo' | OhanaSMC"
  end

  scenario 'when performing a search and visiting details page' do
    search(:path=>'/',:keyword=>'food',:location=>'san mateo')
    visit_details
    looks_like_details("Urban Table Certified Farmer's Market")
  end

  # visiting pages via ajax
  scenario 'when performing a search and visiting results page via ajax',
  :js=>true do
    search(:path=>'/')
    search(:keyword=>'food',:location=>'san mateo')
    looks_like_results
    expect(page).to have_title "Showing 9 of 9 results matching 'food' within 2 miles of 'san mateo' | OhanaSMC"
  end

  scenario 'when performing a search and visiting details page via ajax',
  :js=>true do
    search(:path=>'/',:keyword=>'food',:location=>'san mateo')
    visit_details
    looks_like_details("Urban Table Certified Farmer's Market")
  end

end