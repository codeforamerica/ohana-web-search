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
    search_from_home(:keyword=>'family')
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.next')
      expect(page).to have_content('123')
    end
  end

  scenario 'on last page with less than 4 pages of results', :vcr do
    search_from_home(:keyword=>'family')
    go_to_page(3)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_content('123')
    end
  end

  scenario 'on first page with more than 5 pages of results', :vcr do
    search_from_home
    clear_filters_and_update
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.next')
      expect(page).to have_content('12345…12')
    end
  end

  scenario 'on last page with more than 5 pages of results', :vcr do
    search_from_home
    clear_filters_and_update
    go_to_page(12)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_content('1…89101112')
    end
  end

  scenario 'less than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    clear_filters_and_update
    go_to_page(3)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('12345…12')
    end
  end

  scenario 'more than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    clear_filters_and_update
    go_to_page(4)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…23456…12')
    end
  end

  scenario 'less than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    clear_filters_and_update
    go_to_page(12)
    go_to_page(10)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…89101112')
    end
  end

  scenario 'more than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    clear_filters_and_update
    go_to_page(12)
    go_to_page(8)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…678910…12')
    end
  end
end
