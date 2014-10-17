require 'rails_helper'

feature 'clicking search links from details page', :vcr do

  before { visit_test_location }

  context 'when clicking organization link in location detail view' do
    it 'displays locations that belong to that organization' do
      first('#detail-info header').click_link('SanMaceo Example Agency.')
      expect(page.find('#list-view')).to have_link('San Maceo Agency')
    end
  end

  context 'when clicking ZIP code link in location address' do
    it 'displays locations that are nearby to that ZIP code' do
      first('#contact-info .address').click_link('05201')
      expect(page.find('#list-view')).to have_link('San Maceo Agency')
    end
  end

  context 'when clicking ZIP code link in location mailing address' do
    it 'displays locations that are nearby to that ZIP code' do
      first('#contact-info .mail-address').click_link('90210')
      expect(page).to have_content('No results found.')
    end
  end
end
