feature 'Visitor performs search on a page other than home' do

  xscenario 'on the organizations index page' do
    organization = FactoryGirl.create(:organization)
    visit ('/organizations')
    search_for_keyword_without_visit 'library'
    expect(page).to have_content("1 result matching 'library'")
    find_field("search_term").value.should == "library"
  end

  xscenario 'on a details page' do
    organization = FactoryGirl.create(:organization)
    visit ('/organizations')
    visit_details
    search_for_keyword_without_visit 'library'
    expect(page).to have_content("1 result matching 'library'")
  end

  xscenario 'and searches for keyword, location and radius' do
    organization = FactoryGirl.create(:organization)
    visit ('/organizations')
    search_all 'library', '94010', '10 miles'
    page.has_select?("miles", :selected => "10 miles").should == true
    visit_details
    page.has_select?("miles", :selected => "10 miles").should == true
    find_field("search_term").value.should == "library"
    find_field("location").value.should == "94010"
    find("#detail-screen").find("nav").find("a").click
    page.has_select?("miles", :selected => "10 miles").should == true
    find_field("search_term").value.should == "library"
    find_field("location").value.should == "94010"
  end
end