require 'spec_helper'

feature "results page pagination", :js=>true do

  scenario 'with results that have no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    expect(page).to_not have_selector('.pagination')
  end

  scenario 'with results that have one result', :vcr do
    search_for_maceo
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1')
  end

  scenario 'on first page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'libraries')
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 >')
  end

  scenario 'on last page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'libraries')
    go_to_page(2)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2')
  end

  scenario 'on first page of results that have more than five entries', :vcr do
    search_from_home
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 3 4 5 ... 20 >')
  end

  scenario 'on last page of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(20)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 ... 16 17 18 19 20')
    expect(page).to have_content('571-589 of 589 results')
  end

  scenario 'on page less than three pages from beginning of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(3)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2 3 4 5 ... 20 >')
  end

  scenario 'on page more than three pages from beginning of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(4)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: <  1 ... 2 3 4 5 6 ... 20 >')
  end

  scenario 'on page less than three pages from end of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(20)
    go_to_page(18)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 16 17 18 19 20 >')
  end

  scenario 'on page more than three pages from end of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(20)
    go_to_page(17)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 15 16 17 18 19 ... 20 >')
  end

end