require 'rails_helper'

feature 'Site Pages' do

  scenario 'when visiting about page directly' do
    visit('/about')
    expect(page).to have_title 'About | SMC-Connect'
    expect(page).to have_content 'Geocoding courtesy of Google'
    expect(page).to have_content 'Anselm Bradford'
    expect(page).to have_content 'Moncef Belyamani'
    expect(page).to have_content 'Sophia Parafina'
    expect(page).to have_selector '#feedback-form-btn'
  end

  scenario 'when visiting results page directly', :vcr do
    search_for_maceo
    looks_like_results
  end
end
