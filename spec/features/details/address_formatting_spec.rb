require 'spec_helper'

feature 'address formatting' do

  context 'when no address elements are present', :vcr do
    before(:each) { visit('/organizations/521d32ff1974fcdb2b00126c') }

    it "does not include the physical address header" do
      page.should_not have_content("Physical Address")
    end

    it "does not include a Google Maps directions link" do
      page.should_not have_content('Directions')
    end
  end

  context 'when all address elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes the address header" do
      page.should have_content("Address")
    end

    it "includes the street address" do
      page.should have_content("2013 Avenue of the fellows")
    end

    it "includes a Google Maps directions link to the address" do
      string = "https://maps.google.com/maps?saddr=current+location"
      string << "&daddr=2013 Avenue of the fellows, Suite 100,"
      string << " Burlington, VT 05201"
      page.should have_link('Directions', :href => string)
    end
  end

end