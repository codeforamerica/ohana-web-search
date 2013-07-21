require 'spec_helper'

feature 'Visitor views a page that is loaded via ajax' do

  scenario 'details page is displayed via ajax', 
  :js=>true do
    search_for_keyword('Service League of San Mateo County')
    page.find(:css, '#list-view li:first-child a').click
    find(:css, "#detail-info .description a").should have_content("more")
    find(:css, "#detail-info .description a").click
  end

  scenario 'search results list is updated via ajax', 
  :js=>true do
    search_for_nothing
    search_for_keyword('Service League of San Mateo County')
    looks_like_results_list
  end

end