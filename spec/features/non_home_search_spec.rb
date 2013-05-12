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

  scenario 'and selects a radius of 10 miles' do
    organization = FactoryGirl.create(:organization)
    visit ('/organizations')
    search_for_keyword_and_distance 'library', '10 miles'
    page.has_select?("miles", :selected => "10 miles").should == true
    visit_details
    page.has_select?("miles", :selected => "10 miles").should == true
    find("#detail-screen").find("nav").find("a").click
    page.has_select?("miles", :selected => "10 miles").should == true
  end
end