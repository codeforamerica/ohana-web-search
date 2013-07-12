feature 'Visitor performs search on a page other than home' do

  scenario 'on the organizations index page' do
    visit ('/organizations')
    search_for_keyword_without_visit 'library'
    expect(page).to have_content("results matching 'library'")
    find_field("keyword").value.should == "library"
  end

  scenario 'on a details page' do
    visit ('/organizations')
    visit_details
    search_for_keyword_without_visit 'library'
    expect(page).to have_content("results matching 'library'")
  end

  scenario 'and searches for keyword, location and radius' do
    visit ('/organizations')
    search_all 'library', '94010', '5 miles'
    page.has_select?("radius", :selected => "5 miles").should == true
    visit_details
    page.has_select?("radius", :selected => "5 miles").should == true
    find_field("keyword").value.should == "library"
    find_field("location").value.should == "94010"

    find("#results-container").find("nav").find("a").click
    page.has_select?("radius", :selected => "5 miles").should == true
    find_field("keyword").value.should == "library"
    find_field("location").value.should == "94010"
  end
end