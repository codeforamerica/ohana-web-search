require 'rails_helper'

describe 'kind filter', :vcr do
  context 'when visiting /locations' do
    it 'does not check any Kind checkboxes by default' do
      visit '/locations'
      uncheck 'service_area'
      expect(find('#kind-arts')).to_not be_checked
      expect(find('#kind-clinics')).to_not be_checked
      expect(find('#kind-education')).to_not be_checked
      expect(find('#kind-entertainment')).to_not be_checked
      expect(find('#kind-farmers-markets')).to_not be_checked
      expect(find('#kind-government')).to_not be_checked
      expect(find('#kind-human-services')).to_not be_checked
      expect(find('#kind-libraries')).to_not be_checked
      expect(find('#kind-museums')).to_not be_checked
      expect(find('#kind-other')).to_not be_checked
      expect(find('#kind-parks')).to_not be_checked
      expect(find('#kind-sports')).to_not be_checked
    end
  end

  context 'when checking a single Kind checkbox' do
    it 'restricts results to those with a matching Kind' do
      visit '/locations'
      check 'kind-arts'
      find('#button-search').click
      expect(current_url).to include('kind[]=Arts')
    end
  end

  context 'when checking multiple Kind checkboxes' do
    it 'restricts results to those matching either Kind options' do
      visit '/locations'
      check 'kind-arts'
      check 'kind-human-services'
      find('#button-search').click
      expect(current_url).to include('kind[]=Arts&kind[]=Human+Services')
    end
  end

  context 'when unchecking then checking a Kind checkbox' do
    it 'restricts results to those matching the Kind option' do
      visit '/locations?kind[]=Arts'
      uncheck 'kind-arts'
      find('#button-search').click
      expect(current_url).to_not include('kind[]=')
      check 'kind-entertainment'
      find('#button-search').click
      expect(current_url).to include('kind[]=Entertainment')
      expect(current_url).to_not include('kind[]=Arts')
    end
  end
end
