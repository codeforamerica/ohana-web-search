require 'rails_helper'

feature 'phone number formatting' do
  scenario 'when separated by dash' do
    VCR.use_cassette('dynamic/location_details/phone_dynamic',
                     erb: { first_general_number: '703-555-1212' }) do
      visit_test_location
      expect(page).to have_content('(703) 555-1212')
    end
  end

  scenario 'when all together' do
    VCR.use_cassette('dynamic/location_details/phone_dynamic',
                     erb: { first_general_number: '7035551212' }) do
      visit_test_location
      expect(page).to have_content('(703) 555-1212')
    end
  end

  scenario 'when separated by dot' do
    VCR.use_cassette('dynamic/location_details/phone_dynamic',
                     erb: { first_general_number: '703.555.1212' }) do
      visit_test_location
      expect(page).to have_content('(703) 555-1212')
    end
  end

  scenario 'when separated by space' do
    VCR.use_cassette('dynamic/location_details/phone_dynamic',
                     erb: { first_general_number: '703 555 1212' }) do
      visit_test_location
      expect(page).to have_content('(703) 555-1212')
    end
  end

  scenario 'when less than 10 digits' do
    VCR.use_cassette('dynamic/location_details/phone_dynamic',
                     erb: { first_general_number: '703-555-121' }) do
      visit_test_location
      expect(page).to have_content('703-555-121')
    end
  end

  scenario 'when more than 10 digits' do
    VCR.use_cassette('dynamic/location_details/phone_dynamic',
                     erb: { first_general_number: '703-555-12123' }) do
      visit_test_location
      expect(page).to have_content('703-555-12123')
    end
  end
end
