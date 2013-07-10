require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'OhanaSMC'" do
      visit "/"
      page.should have_content('OhanaSMC')
      page.should have_content('I need')
      page.should have_content('I am near')
      page.should have_title('OhanaSMC')
    end

    it "should have the about popup" do
      visit "/"
      page.has_css?("#about-box").should == true
      page.should have_content('About')
    end
  end

end