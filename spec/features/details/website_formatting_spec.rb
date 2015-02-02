require 'rails_helper'

feature 'url formatting' do
  scenario 'when contains https://' do
    VCR.use_cassette('dynamic/location_details/website_dynamic',
                     erb: { website: 'https://www.smctest.org' }) do
      visit_test_location
      within('.location-sidebar .website') do
        expect(find_link('www.smctest.org')[:href]).
          to eq('https://www.smctest.org')
      end
    end
  end

  scenario 'when contains http://' do
    VCR.use_cassette('dynamic/location_details/website_dynamic',
                     erb: { website: 'http://www.smctest.org' }) do
      visit_test_location
      within('.location-sidebar .website') do
        expect(find_link('www.smctest.org')[:href]).
          to eq('http://www.smctest.org')
      end
    end
  end

  scenario 'when does not contain http:// or https://' do
    VCR.use_cassette('dynamic/location_details/website_dynamic',
                     erb: { website: 'smctest.org' }) do
      visit_test_location
      within('.location-sidebar .website') do
        expect(find_link('smctest.org')[:href]).to eq('smctest.org')
      end
    end
  end

  scenario 'when malformed' do
    VCR.use_cassette('dynamic/location_details/website_dynamic',
                     erb: { website: 'http:/www.smctest.org' }) do
      visit_test_location
      within('.location-sidebar .website') do
        expect(find_link('http:/www.smctest.org')[:href]).
          to eq('http:/www.smctest.org')
      end
    end
  end
end
