require 'rails_helper'

describe 'service area filter', :vcr do
  context 'when clicking a link from the homepage' do
    it 'does not automatically set service_area=smc' do
      visit '/'
      click_link 'CalFresh'
      expect(current_url).to_not include('service_area=smc')
    end

    it 'does not check the service area checkbox on the search results page' do
      visit '/'
      click_link 'CalFresh'
      expect(find('#service_area')).to_not be_checked
    end
  end

  context 'when entering a search term from the homepage' do
    it 'does not automatically set service_area=smc' do
      search_from_home(keyword: 'food')
      expect(current_url).to_not include('service_area=smc')
    end
  end

  context 'when unchecking the service area checkbox' do
    it 'includes all service areas' do
      visit '/locations?service_area=smc'
      uncheck 'service_area'
      find('#button-search').click
      expect(current_url).to_not include('service_area=smc')
    end
  end

  context 'when unchecking then checking service area checkbox' do
    it 'restricts service areas' do
      visit '/locations?service_area=smc'
      uncheck 'service_area'
      find('#button-search').click
      check 'service_area'
      find('#button-search').click
      expect(current_url).to include('service_area=smc')
    end
  end
end
