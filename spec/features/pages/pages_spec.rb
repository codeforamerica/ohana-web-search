require "spec_helper"

# checks for correct page titles of site pages
feature 'Site Pages' do

  scenario 'when visiting homepage directly' do
    visit ('/')
    looks_like_homepage
  end

  scenario 'when visiting about page directly' do
    visit ('/about')
    expect(page).to have_title "About | OhanaSMC"
    expect(page).to have_content "Geocoding courtesy of Google"
    expect(page).to have_content "Anselm Bradford"
    expect(page).to have_content "Moncef Belyamani"
    expect(page).to have_content "Sophia Parafina"
    expect(page).to have_content "contribute"
    expect(page).to have_selector "#feedback-form-btn"
  end

  scenario 'when visiting results page directly', :js => true do
    VCR.use_cassette('results/visit_directly') do
      visit ('/organizations?utf8=%E2%9C%93&keyword=maceo&location=')
      looks_like_results
    end
  end

end
