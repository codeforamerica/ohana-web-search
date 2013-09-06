require 'spec_helper'

feature 'address formatting' do

  context 'when no address elements are present', :vcr do
    before(:each) { visit('/organizations/521d32ff1974fcdb2b00126c') }

    it "does not include the address header" do
      expect(page).to_not have_content("Address")
    end

    it "does not include a Google Maps directions link" do
      expect(page).to_not have_content('Directions')
    end
  end

  context 'when no nearby locations are not present', :vcr do
    before(:each) { visit('/organizations/521d32c61974fcdb2b0002c2') }

    it "does not include nearby locations control"
      within('#show-nearby-control') do
        expect(page).to have_content("NOTE: No nearby services at this location")
      end
    end

  end

  context 'when nearby locations are present', :vcr do
    before(:each) { visit('/organizations/521d32b91974fcdb2b000002') }

    it "does include nearby locations control" do
      within('#show-nearby-control') do
        expect(page).to have_content("Show nearby services")
      end
    end

    it "does show nearby locations control was clicked" do
      find(:css, '#show-nearby-control').click
      within('#show-nearby-control') do
        expect(page).to have_content("30 nearby services located • Hide nearby services")
      end
    end
  end

  context 'when all address elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes the address header" do
      expect(page).to have_content("Address")
    end

    it "includes the street address" do
      expect(page).to have_content("2013 Avenue of the fellows")
    end

    it "includes a Google Maps directions link to the address" do
      string = "https://maps.google.com/maps?saddr=current+location"
      string << "&daddr=2013 Avenue of the fellows, Suite 100,"
      string << " San Maceo, CA 99999"
      expect(page).to have_link('Directions', :href => string)
    end
  end

end