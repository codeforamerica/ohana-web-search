require 'spec_helper'

# Tests the results page pagination component. This only checks one of the three components on the page,
# as all should be duplicates of each other.
feature "results page pagination", :js=>true do

  scenario 'with results that have no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    page.should_not have_selector('.pagination')
  end

  scenario 'with results that have one result', :vcr do
    search_for_maceo
    within('#floating-results-header .pagination') do
      page.should have_content('1')
    end
  end

  scenario 'on first page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'libraries')
    within("#floating-results-header .pagination") do
      page.should have_selector('.next')
      page.should have_content('1 2')
    end
  end

  scenario 'on last page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'libraries')
    go_to_page(2)
    within('#floating-results-header .pagination') do
      page.should have_selector('.prev')
      page.should have_content('1 2')
    end
  end

  scenario 'on first page of results that have more than five entries', :vcr do
    search_from_home
    within('#floating-results-header .pagination') do
      page.should have_selector('.next')
      page.should have_content('1 2 3 4 5 … 20')
    end
  end

  scenario 'on last page of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(20)
    page.should have_content('571-589 of 589 results')
    within('#floating-results-header .pagination') do
      page.should have_selector('.prev')
      page.should have_content('1 … 16 17 18 19 20')
    end
  end

  scenario 'on page less than three pages from beginning of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(3)
    within('#floating-results-header .pagination') do
      page.should have_selector('.prev')
      page.should have_selector('.next')
      page.should have_content('1 2 3 4 5 … 20')
    end
  end

  scenario 'on page more than three pages from beginning of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(4)
    within('#floating-results-header .pagination') do
      page.should have_selector('.prev')
      page.should have_selector('.next')
      page.should have_content('1 … 2 3 4 5 6 … 20')
    end
  end

  scenario 'on page less than three pages from end of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(20)
    go_to_page(18)
    within('#floating-results-header .pagination') do
      page.should have_selector('.prev')
      page.should have_selector('.next')
      page.should have_content('1 … 16 17 18 19 20')
    end
  end

  scenario 'on page more than three pages from end of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(20)
    go_to_page(17)
    within('#floating-results-header .pagination') do
      page.should have_selector('.prev')
      page.should have_selector('.next')
      page.should have_content('1 … 15 16 17 18 19 … 20')
    end
  end

end