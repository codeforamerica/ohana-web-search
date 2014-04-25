require 'spec_helper'

<<<<<<< HEAD
# Tests the results page pagination component. This only checks one of the three components on the page,
# as all should be duplicates of each other.
feature "results page pagination", :js=>true do
=======
feature "results page pagination" do
>>>>>>> master

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

<<<<<<< HEAD
  scenario 'on first page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'libraries')
    within("#floating-results-header .pagination") do
      expect(page).to have_selector('.next')
      expect(page).to have_content('12')
    end
  end

  scenario 'on last page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'libraries')
    go_to_page(2)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_content('12')
    end
=======
  scenario 'on first page with less than 4 pages of results', :vcr do
    search_from_home(:keyword=>'youth')
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 3 >')
  end

  scenario 'on last page with less than 4 pages of results', :vcr do
    search_from_home(:keyword=>'youth')
    go_to_page(3)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2 3')
>>>>>>> master
  end

  scenario 'on first page with more than 5 pages of results', :vcr do
    search_from_home
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.next')
      expect(page).to have_content('12345…20')
    end
  end

  scenario 'on last page with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(20)
    expect(page).to have_content('571-589 of 589 results')
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_content('1…1617181920')
    end
  end

  scenario 'less than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(3)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('12345…20')
    end
  end

  scenario 'more than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(4)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…23456…20')
    end
  end

  scenario 'less than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    go_to_page(20)
    go_to_page(18)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…1617181920')
    end
  end

  scenario 'more than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(20)
    go_to_page(17)
    within('#floating-results-header .pagination') do
      expect(page).to have_selector('.prev')
      expect(page).to have_selector('.next')
      expect(page).to have_content('1…1516171819…20')
    end
  end

end