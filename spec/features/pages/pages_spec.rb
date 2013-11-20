require "spec_helper"

# checks for correct page titles of site pages
feature 'Site Pages' do

  scenario 'when visiting homepage directly' do
    visit ('/')
    looks_like_homepage
  end

  scenario 'when visiting about page directly' do
    visit ('/about')
    page.should have_title "About | SMC-Connect"
    page.should have_content "Geocoding courtesy of Google"
    page.should have_content "Anselm Bradford"
    page.should have_content "Moncef Belyamani"
    page.should have_content "Sophia Parafina"
    page.should have_content "contribute"
    page.should have_selector "#feedback-form-btn"
  end

  @javascript
  scenario 'when visiting results page directly', :vcr do
    visit ('/organizations?utf8=%E2%9C%93&keyword=maceo')
    looks_like_results
  end

end
