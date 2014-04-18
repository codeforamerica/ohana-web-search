require 'spec_helper'

feature "results page pagination" do

  scenario 'when there are no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    expect(page).not_to have_selector('.pagination')
  end

  scenario 'when there is only one result', :vcr do
    search_for_maceo
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1')
  end

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
  end

  scenario 'on first page with more than 5 pages of results', :vcr do
    search_from_home
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 3 4 5 ... 22 >')
  end

  scenario 'on last page with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 ... 18 19 20 21 22')
    expect(page).to have_content('22-22 of 22 results')
  end

  scenario 'less than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(3)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2 3 4 5 ... 22 >')
  end

  scenario 'more than 3 pages in with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(4)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: <  1 ... 2 3 4 5 6 ... 22 >')
  end

  scenario 'less than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    go_to_page(20)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 18 19 20 21 22 >')
  end

  scenario 'more than 3 pages out with more than 5 pages of results', :vcr do
    search_from_home
    go_to_page(22)
    go_to_page(18)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 16 17 18 19 20 ... 22 >')
  end

end