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
      expect(all(element).last).to have_content('Passport Photos')
    end

    it 'includes alternate name' do
      element = '.services-box .alternate-name'
      expect(all(element).last).to have_content('(Fotos para pasaportes)')
    end

    it 'includes website' do
      element = '.services-box .website'
      expect(all(element).last).to have_content('www.example.com')
    end

    it 'includes email' do
      element = '.services-box .email'
      expect(all(element).last).to have_content('passports@example.org')
    end

    it 'includes the phone number, extension, type, and department' do
      element = '.services-box .phones'
      expect(find(element)).to have_content('(123) 456-7890 x 123 voice Passport Photos')
    end

    it 'includes description' do
      element = '.services-box .description'
      expect(all(element).last).to have_content('Lorem ipsum')
    end

    it 'includes fees' do
      expect(page).to have_content('permits and photocopying')
    end

    it 'includes audience' do
      expect(page).to have_content('Profit and nonprofit businesses')
    end

    it 'includes eligibility' do
      element = '.services-box .eligibility'
      expect(all(element).last).to have_content('None')
    end

    it 'includes interpretation services' do
      element = '.services-box .interpretation-services'
      expect(all(element).last).to have_content('3-way interpretation')
    end

    it 'includes how to apply' do
      expect(page).to have_content('Walk in or apply by phone or mail')
    end

    it 'includes wait estimate' do
      expect(page).to have_content('No wait to 2 weeks')
    end

    it 'includes required documents' do
      element = '.services-box .required-documents'
      expect(first(element)).to have_content('Government-issued picture')
    end

    it 'includes accepted payment methods' do
      element = '.services-box .accepted-payments'
      expect(first(element)).to have_content('Credit Card')
    end

    it 'includes service areas' do
      expect(page).to have_content('San Mateo County')
    end

    it 'includes regular hour schedule' do
      content = 'Monday: 8:00am - 12:00pm'
      expect(find('.services-box .regular-schedules')).to have_content(content)
    end

    it 'includes holiday hour schedule' do
      content = 'January 1: CLOSED'
      expect(find('.services-box .holiday-schedules')).to have_content(content)
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
