require 'spec_helper'

feature 'address formatting' do

  context 'when no address elements are present', :vcr do
    before(:each) { visit_location_with_no_address }

    it "does not include the physical address header" do
      expect(page).not_to have_content("Physical Address")
    end

    it "does not include a Google Maps directions link" do
      expect(page).not_to have_content('Directions')
    end
  end

  context 'when all address elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit_test_location
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
      string << " Burlington, VT 05201"
      expect(page).to have_link('Directions', :href => string)
    end
  end

end