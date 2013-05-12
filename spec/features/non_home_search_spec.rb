feature 'Visitor performs search on a page other than home' do

  scenario 'on the organizations index page' do
    organization = FactoryGirl.create(:organization)
    visit ('/organizations')
    search_for_keyword_without_visit 'library'
    expect(page).to have_content("1 organization matching 'library'")
  end

  scenario 'on a details page' do
    organization = FactoryGirl.create(:organization)
    visit ('/organizations')
    visit_details
    search_for_keyword_without_visit 'library'
    expect(page).to have_content("1 organization matching 'library'")
  end

end