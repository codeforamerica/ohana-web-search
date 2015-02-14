require 'rails_helper'

feature 'results list' do
  scenario 'displays the first voice number when voice number is first' do
    VCR.use_cassette('dynamic/location_details/phone_type_dynamic',
                     erb: { first_general_number_type: 'voice',
                            second_general_number_type: 'hotline',
                            third_general_number_type: 'fax',
                            fourth_general_number_type: 'tty' }) do
      search_for_example
      expect(find('.phone')).to have_content('(650) 372-6200')
    end
  end

  scenario 'displays the first hotline number when hotline number is first' do
    VCR.use_cassette('dynamic/location_details/phone_type_dynamic',
                     erb: { first_general_number_type: 'hotline',
                            second_general_number_type: 'voice',
                            third_general_number_type: 'fax',
                            fourth_general_number_type: 'tty' }) do
      search_for_example
      expect(find('.phone')).to have_content('(650) 372-6200')
    end
  end

  scenario 'displays the first voice number when fax number is first' do
    VCR.use_cassette('dynamic/location_details/phone_type_dynamic',
                     erb: { first_general_number_type: 'fax',
                            second_general_number_type: 'voice',
                            third_general_number_type: 'hotline',
                            fourth_general_number_type: 'tty' }) do
      search_for_example
      expect(find('.phone')).to have_content('(650) 627-8244')
    end
  end

  scenario 'displays no number when only fax number is present' do
    VCR.use_cassette('dynamic/location_details/phone_type_dynamic',
                     erb: { first_general_number_type: 'fax',
                            second_general_number_type: 'fax',
                            third_general_number_type: 'fax',
                            fourth_general_number_type: 'tty' }) do
      search_for_example
      expect(page).to_not have_selector('.phone')
    end
  end
end
