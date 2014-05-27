require 'spec_helper'

feature "results page pagination" do

  scenario 'when there are no results', :vcr do
    search_from_home(keyword: 'asdfg')
    expect(page).not_to have_selector('.pagination')
  end

  scenario 'when there is only one result', :vcr do
    search_for_maceo
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1')
  end

  scenario 'on first page with less than 4 pages of results', :vcr do
    search_from_home(keyword: 'health')
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 3 >')
  end

  scenario 'on last page with less than 4 pages of results', :vcr do
    search_from_home(keyword: 'health')
    go_to_page(3)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2 3')
  end

  scenario 'on first page with more than 5 pages of results', :vcr do
    visit('/organizations')
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: 1 2 3 4 5 ... 12 >')
  end

  scenario 'on last page with more than 5 pages of results', :vcr do
    visit('/organizations')
    go_to_page(12)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 ... 8 9 10 11 12')
    expect(page).to have_content('331-339 of 339 results')
  end

  scenario 'less than 3 pages in with more than 5 pages of results', :vcr do
    visit('/organizations')
    go_to_page(3)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: < 1 2 3 4 5 ... 12 >')
  end

  scenario 'more than 3 pages in with more than 5 pages of results', :vcr do
    visit('/organizations')
    go_to_page(4)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('Page: <  1 ... 2 3 4 5 6 ... 12 >')
  end

  scenario 'less than 3 pages out with more than 5 pages of results', :vcr do
    visit('/organizations')
    go_to_page(12)
    go_to_page(10)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 8 9 10 11 12 >')
  end

  scenario 'more than 3 pages out with more than 5 pages of results', :vcr do
    visit('/organizations')
    go_to_page(12)
    go_to_page(8)
    expect(page).to have_selector('.pagination')
    expect(page).to have_content('<  1 ... 6 7 8 9 10 ... 12 >')
  end
end
