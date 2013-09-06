require 'spec_helper'

feature "location details", :js => true do

  context "when the details page is visited via search results" do
    background do
      VCR.use_cassette('location_details/search_and_visit') do
        search_from_home(:keyword => 'maceo')
        visit_details
      end
    end

    scenario 'when location has an address' do
      expect(page).to have_content("Address")
      expect(page).to have_content("2013 Avenue of the fellows")
    end

    scenario 'return to search results via details page', :vcr do
      find_link("Result list").click
      page.find("#search-summary").
        should have_content("1 of 1 result matching 'maceo'")
    end
  end

  scenario "when the details page is visited directly", :vcr do
    visit('/organizations/521d33a01974fcdb2b0026a9')
    expect(page).to have_content("2013 Avenue of the fellows")
  end

  scenario "when the details page is visited directly with invalid id", :vcr do
    visit('/organizations/1234')
    expect(page).to have_content("CalFresh")
    expect(page).to have_title "SMC-Connect"
  end

  context 'when phone elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes the Contact header" do
      expect(page).to have_content("Contact")
    end

    it "includes the department and phone hours" do
      expect(page).to have_content("Information (650) 372-6200 (Monday-Friday,
        8-5)")
    end

    it "includes the Fax number" do
      expect(page).to have_content("(650) 627-8244")
    end

    it "specifies TTY numbers" do
      expect(page).to have_content("(650) 372-6200 (TTY)")
    end

  end

  context 'when service elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes eligibility info" do
      expect(page).to have_content("Everyone")
    end

    it "includes audience info" do
      expect(page).to have_content("Profit and nonprofit businesses")
    end

    it "includes fees info" do
      expect(page).to have_content("permits and photocopying")
    end

    it "includes hours info" do
      expect(page).to have_content("Monday-Friday, 8-5; Saturday, 10-6; Sunday 11-5")
    end

    it "includes how to apply info" do
      expect(page).to have_content("Walk in or apply by phone or mail")
    end

    it "includes wait info" do
      expect(page).to have_content("No wait to 2 weeks")
    end

    it "includes service areas" do
      expect(page).to have_content("Marin County")
    end

    it "includes updated time" do
      expect(page).to have_content("Tuesday, 27 August 2013 at 4:17 PM")
    end

  end

  context 'when location elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes URLs" do
      expect(page).to have_link("http://www.smchealth.org")
    end

    it "includes accessibility info" do
      expect(page).to_not have_content("Disabled Parking")
    end

    it "includes ask for info" do
      expect(page).to have_content("Dawn of Midi")
    end

    it "doesn't display ask for as an array" do
      expect(page).to_not have_content("[James Brown, Dawn of Midi]")
    end

    it "includes Contact info" do
      expect(page).to have_content("Suzanne Badenhoop")
    end

    it "includes email info" do
      expect(page).to have_link("sanmaceo@co.sanmaceo.ca.us")
    end

    it "includes hours info" do
      expect(page).to have_content("Monday-Friday, 8-5; Saturday, 10-6; Sunday 11-5")
    end

    it "includes languages info" do
      expect(page).to have_content("Chinese (Cantonese)")
    end

    it "includes Mailing Address info" do
      expect(page).to have_content("Hella Fellas")
    end

    it "includes description" do
      expect(page).to have_content("Lorem ipsum")
    end

    it "includes short description" do
      expect(page).to have_content("Works to control")
    end

    it "includes transporation info" do
      expect(page).to have_content("SAMTRANS stops within 1 block")
    end

    it "sets the page title to the location name" do
      expect(page).to have_title("San Maceo Agency | SMC-Connect")
    end
  end

  context 'when farmers market with market match' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes Market Match" do
      expect(page).to have_content("Market Match")
    end

    it "includes payment info" do
      expect(page).to have_content("Payments Accepted")
    end

    it "includes info about payment types" do
      expect(page).to have_content("SNAP")
    end

    it "includes products info" do
      expect(page).to have_content("Products Sold")
    end
  end
end
