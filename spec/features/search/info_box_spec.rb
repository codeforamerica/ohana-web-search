require 'rails_helper'

feature 'info box', :vcr do
  scenario "with keyword that doesn't match info box synonym" do
    visit('/locations?keyword=food')
    expect(page).not_to have_selector('#terminology-box-container')
  end

  context 'with keyword that matches info box synonym' do
    before(:each) { visit('/locations?keyword=wic') }

    it 'displays section with a #terminology id' do
      expect(page).to have_selector('#terminology-box-container')
    end

    it 'displays the title in a <dt> tag' do
      within('#terminology-box-container') do
        expect(page).to have_xpath('//dl/dt')
        expect(page.first('dt').text).to eq 'Women, Infants, and Children'
      end
    end

    it 'displays the description in a <dd> tag' do
      within('#terminology-box-container') do
        expect(page).to have_xpath('//dl/dd')
        expect(page.first('dd').text).to include('provides assistance')
      end
    end

    it 'displays the url when one is present' do
      within('#terminology-box-container') do
        expect(page).
          to have_link('More info...', href: 'http://www.fns.usda.gov/wic')
      end
    end
  end

  context 'when info box does not have an url' do
    it 'does not display the More info link' do
      visit('/locations?keyword=snap')
      expect(page).not_to have_link('More info...')
    end
  end

  scenario 'with keyword that matches synonym from custom info box' do
    search_from_home(keyword: 'health care reform')
    expect(page).to have_selector('#terminology-box-container')
    within('#terminology-box-container') do
      expect(page).to have_selector('table')
      expect(page).to have_content('$15,856')
    end
  end
end
