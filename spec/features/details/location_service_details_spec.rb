require 'rails_helper'

feature 'location service details' do

  context 'when service elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes name' do
      element = '.services-box .name'
      expect(first(element)).to have_content('Passport Photos')
    end

    it 'includes alternate name' do
      element = '.services-box .alternate-name'
      expect(first(element)).to have_content('(Fotos para pasaportes)')
    end

    it 'includes website' do
      element = '.services-box .website'
      expect(first(element)).to have_content('www.example.com')
    end

    it 'includes email' do
      element = '.services-box .email'
      expect(first(element)).to have_content('passports@example.org')
    end

    it 'includes description' do
      element = '.services-box .description'
      expect(first(element)).to have_content('Lorem ipsum')
    end

    it 'includes fees info' do
      expect(page).to have_content('permits and photocopying')
    end

    it 'includes audience info' do
      expect(page).to have_content('Profit and nonprofit businesses')
    end

    it 'includes eligibility info' do
      expect(page).to have_content('None')
    end

    it 'includes how to apply info' do
      expect(page).to have_content('Walk in or apply by phone or mail')
    end

    it 'includes wait estimate info' do
      expect(page).to have_content('No wait to 2 weeks')
    end

    it 'includes required documents' do
      element = '.services-box .required-documents'
      expect(first(element)).to have_content('Government-issued identification')
    end

    it 'includes accepted payment methods' do
      element = '.services-box .accepted-payments'
      expect(first(element)).to have_content('Credit Card')
    end

    it 'includes service areas info' do
      expect(page).to have_content('San Mateo County')
    end

    it 'includes hours info' do
      expect(page).to have_content('Monday-Friday, 8-5; Saturday, 10-6;')
    end
  end

  context 'when service element status is present', :vcr do
    it 'includes defunct status notice' do
      visit('/locations/fake-org/location-with-no-phone')
      element = '.services-box .status'
      expect(find(element)).to have_content(I18n.t('service_fields.status_defunct'))
    end

    it 'includes inactive status notice' do
      visit('/locations/admin-test-org/admin-test-location')
      element = '.services-box .status'
      expect(find(element)).to have_content(I18n.t('service_fields.status_inactive'))
    end
  end
end
