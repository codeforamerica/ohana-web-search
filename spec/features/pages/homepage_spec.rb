require "spec_helper"

describe "Home page header elements" do

  before(:each) do
    visit "/"
  end

  it 'includes expected homepage content' do
    expect(page).to have_title "SMC-Connect"
    expect(page).to have_content "About"
    expect(page).to have_content "Contribute"
    expect(page).to have_content "Feedback"
  end

end

describe "Home page content elements" do

  before(:each) do
    visit "/"
  end

  it 'includes expected homepage content' do
    expect(page).to have_content "I need"
    expect(page).to have_content "reporting"
    expect(page).to have_content "government assistance"
    expect(page).to_not have_title "1 result"
    expect(find("#language-box")).to have_content("English")
  end

end

describe "Home page footer elements" do

  before(:each) do
    visit "/"
  end

  it "includes a link to ohanapi.org" do
    within("#app-footer") do
      find_link('view project details')[:href].should == 'http://ohanapi.org'
    end
  end

  it "includes a link to codeforamerica.org" do
    within("#app-footer") do
      find_link('Code for America')[:href].should == 'http://codeforamerica.org'
    end
  end

  it "includes a link to the ohana-web-search GitHub repo" do
    within("#app-footer") do
      find_link('Get this app')[:href].
        should == 'https://github.com/codeforamerica/ohana-web-search'
    end
  end
end