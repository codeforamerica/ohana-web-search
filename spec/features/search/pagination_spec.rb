require 'rails_helper'

feature 'results page pagination', :vcr do
  context 'when there are no results' do
    before { visit '/locations?keyword=asdfg' }

    it 'does not include pagination' do
      expect(page).not_to have_selector('.pagination')
    end

    it 'displays an appropriate search summary' do
      within('#floating-results-header .search-summary') do
        expect(page).to have_content('No results found')
      end
    end
  end

  context 'when there is only one result' do
    before { visit '/locations?keyword=example' }

    it 'does not include pagination' do
      expect(page).not_to have_selector('.pagination')
    end

    it 'displays an appropriate search summary' do
      within('#floating-results-header .search-summary') do
        expect(page).to have_content('Displaying 1 result')
      end
    end
  end

  context 'when there is only one page of results but more than 1 result' do
    before { visit '/locations?keyword=youth&per_page=5' }

    it 'does not include pagination' do
      expect(page).not_to have_selector('.pagination')
    end

    it 'does not include a link to the next page' do
      expect(page).not_to have_selector('.next')
    end

    it 'displays an appropriate search summary' do
      within('#floating-results-header .search-summary') do
        expect(page).to have_content('Displaying all 3 results')
      end
    end
  end

  context 'when on first page of more than one page of results' do
    before { visit '/locations?keyword=youth' }

    it 'includes pagination' do
      expect(page).to have_selector('.pagination')
    end

    it 'does not include a link to the first page' do
      expect(page).not_to have_selector('.first')
    end

    it 'includes a link to the next page' do
      expect(page).to have_selector('.next')
    end

    it 'displays an appropriate search summary' do
      within('#floating-results-header .search-summary') do
        expect(page).to have_content('Displaying 1 - 1 of 3 results')
      end
    end
  end

  context 'when past first page of results but not last page' do
    before(:each) do
      visit '/locations?keyword=youth'
      go_to_page(2)
    end

    it 'does not include a link to the first page' do
      expect(page).not_to have_selector('.first')
    end

    it 'includes a link to the next page' do
      expect(page).to have_selector('.next')
    end

    it 'includes a link to the previous page' do
      expect(page).to have_selector('.prev')
    end

    it 'does not include a link to the last page' do
      expect(page).not_to have_selector('.last')
    end
  end

  context 'when on last page of results' do
    before { visit '/locations?keyword=youth&page=3' }

    it 'does not include a link to the next page' do
      expect(page).not_to have_selector('.next')
    end

    it 'includes a link to the previous page' do
      expect(page).to have_selector('.prev')
    end

    it 'does not include a link to the last page' do
      expect(page).not_to have_selector('.last')
    end
  end
end
