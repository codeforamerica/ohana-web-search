require 'spec_helper'

# Tests the results page pagination component. This only checks one of the three components on the page,
# as all should be duplicates of each other.
feature "results page pagination" do

  scenario 'when there are no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    expect(page).not_to have_selector('.pagination')
  end

  scenario 'when there is only one result', :vcr do
    search_for_maceo
    within('#floating-results-header .pagination') do
      expect(page).to have_content('1')
    end
  end

  scenario 'on first page with less than 4 pages of results', :vcr do
    search_from_home(:keyword=>'youth')
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.next')
      expect(page).to have_content('123')
    end
  end

  scenario 'on last page with less than 4 pages of results', :vcr do
    search_from_home(:keyword=>'youth')
    go_to_page(3)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_content('123')
    end
  end

  scenario 'on first page with more than 5 pages of results', :vcr do
    search_from_home
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.next')
      expect(page).to have_content('12345…22')
    end
  end

  scenario 'on last page with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_content('1…1819202122')
    end
  end

  scenario 'less than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(3)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('12345…22')
    end
  end

  scenario 'more than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(4)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…23456…22')
    end
  end

  scenario 'less than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    go_to_page(20)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…1819202122')
    end
  end

  scenario 'more than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    go_to_page(18)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…1617181920…22')
    end
  end

end