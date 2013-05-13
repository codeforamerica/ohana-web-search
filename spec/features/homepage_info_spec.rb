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

    it "should have the info popup" do
      visit "/"
      find("#logo").find("h1").click
      page.should have_content('Contribute')
      page.should have_content('Credits')
      page.should have_content('Code for America')
      page.should have_link("View source code", :href => "https://github.com/codeforamerica/human_services_finder")
    end
  end

end