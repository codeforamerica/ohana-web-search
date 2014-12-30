require 'rails_helper'

feature 'homepage search' do
  scenario 'with keyword that returns results', :vcr do
    search_for_example
    looks_like_results
    expect(find_field('keyword').value).to eq('example')
    expect(page).not_to have_content('1 result located!')
  end

  scenario 'with keyword that returns no results', :vcr do
    search_from_home(keyword: 'asdfg')
    looks_like_no_results
    expect(page).not_to have_content('No results located!')
  end

  scenario 'when clicking a general link', :vcr do
    visit('/')
    click_link('Health Insurance')
    expect(page).to have_content('Little House')
  end
end
