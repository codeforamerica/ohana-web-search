require 'rails_helper'

feature 'address formatting' do
  context 'when no address elements are present', :vcr do
    before(:each) { visit_location_with_no_address }

    it 'does not include the physical address header' do
      expect(page).not_to have_content('Physical Address')
    end

    it 'does not include a Google Maps directions link' do
      expect(page).not_to have_content('Directions')
    end
  end

  context 'when all address elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes the physical address header' do
      expect(page).to have_content('Physical Address')
    end

    it 'includes the mailing address header' do
      expect(page).to have_content('Mailing Address')
    end

    it 'includes a Google Maps directions link to the address' do
      string = 'https://maps.google.com/maps?saddr=current+location'
      string << '&daddr=2013 Avenue of the fellows, Suite 100,'
      string << ' San Francisco, CA 94103'
      expect(page).to have_link('Directions', href: string)
    end
  end
end
