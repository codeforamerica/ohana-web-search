require 'spec_helper'

feature "results page pagination" do

  scenario 'with results that have no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    expect(page).to_not have_selector('.pagination')
  end

  scenario 'with results that have one result', :vcr do
    search_from_home(:keyword => 'maceo')
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1')
  end

  scenario 'on first page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'market')
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 >')
  end

  scenario 'on last page of results that have less than five entries', :vcr do
    search_from_home(:keyword=>'market')
    go_to_page(2)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2')
  end

  scenario 'on first page of results that have more than five entries', :vcr do
    search_from_home
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 3 4 5 ... 58 >')
  end

  scenario 'on last page of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(58)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 ... 54 55 56 57 58')
    expect(page).to have_content('1711-1712 of 1712 results')
  end

  scenario 'on page less than three pages from beginning of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(3)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2 3 4 5 ... 58 >')
  end

  scenario 'on page more than three pages from beginning of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(4)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: <  1 ... 2 3 4 5 6 ... 58 >')
  end

  scenario 'on page less than three pages from end of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(58)
    go_to_page(56)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 54 55 56 57 58 >')
  end

  scenario 'on page more than three pages from end of results that have more than five entries', :vcr do
    search_from_home
    go_to_page(58)
    go_to_page(55)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 53 54 55 56 57 ... 58 >')
  end

end