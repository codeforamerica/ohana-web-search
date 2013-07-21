require 'spec_helper'

feature 'Visitor views a page that is loaded via ajax' do

  scenario 'details page is displayed via ajax', 
  :js=>true do
    search_for_keyword('Service League of San Mateo County')
    page.find(:css, '#list-view li:first-child a').click
    find(:css, "#detail-info .description a").should have_content("more")
    find(:css, "#detail-info .description a").click
  end

=begin
  xscenario 'search results list is updated via ajax' do

  end

  scenario 'details page is displayed via ajax' do
    search_for_keyword('Service League of San Mateo County')
    visit_details
    within("#detail-info") do
      within(".description")
        expect(page).to have_xpath("//a", text:"more")
      end
    end
  end
=end

end