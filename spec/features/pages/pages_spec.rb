require 'rails_helper'

feature 'Site Pages' do
  scenario 'when visiting about page directly' do
    visit('/about')
    expect(page).to have_title 'About | Ohana Web Search'
    expect(page).to have_content 'Geocoding courtesy of Google'
    expect(page).to have_content 'Anselm Bradford'
    expect(page).to have_content 'Moncef Belyamani'
    expect(page).to have_content 'Sophia Parafina'
    expect(page).to have_selector '#feedback-box .feedback-form'
  end

  scenario 'when visiting results page directly', :vcr do
    search_for_example
    looks_like_results
  end
end
