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
      page.should have_content('Find resources near you')
    end
  end

end