require 'spec_helper'

feature "results page search", :js=>true do

  background do
    page.set_rack_session('aggregate_locations' => [])
    search_from_home(:keyword=>"asdfg")
  end

  # user clicks a filter
  scenario 'when filter has no cached values', :vcr do

    # check filter settings
    expect(all(:css,"#location-options .current-option label").last).to have_content("All")
    find(:css, "#location-options").find(".closed").click
    page.should have_css("#location-options .radio-group", :count=>2)
  end

  scenario 'when filter has custom value and no results', :vcr do
    set_location_filter(:location=>'San Mateo, CA')
    find(:css, "#location-options").find(".open").click
    expect(all(:css,"#location-options .current-option label").last).to have_content("San Mateo, CA")
    find(:css, '#update-btn').click
    find(:css, "#location-options").find(".closed").click
    page.should have_css("#location-options .radio-group", :count=>2)
  end

  scenario 'when filter has custom value and has results', :vcr do
    set_location_filter(:location=>'San Mateo, CA')
    fill_in('keyword', :with => '') # clear keyword
    find(:css, "#location-options").find(".open").click
    expect(all(:css,"#location-options .current-option label").last).to have_content("San Mateo, CA")
    find(:css, '#update-btn').click
    find(:css, "#location-options").find(".closed").click
    page.should have_css("#location-options .radio-group", :count=>3)

    expect(page).to have_content("Peninsula Family Service")
  end


  # user clicks filter links in results list
  scenario 'when clicking organization link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    find("#results-container").first("a", text: "St. Vincent de Paul Society").click
    expect(page).to_not have_content("Shelter Network")
    expect(page).to have_content("San Mateo Homeless Help Center")

    # check filter settings
    expect(all(:css,"#location-options .current-option label").last).to have_content("All")
    expect(all(:css,"#service-area-options .current-option label").last).to have_content("All")
    expect(all(:css,"#kind-options .current-option label").last).to have_content("All")
    expect(all(:css,"#org-name-options .current-option label").last).to have_content("St. Vincent de Paul Society")
  end

  scenario 'when clicking kind link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    find("#results-container").first("a", text: "Human Services").click
    expect(page).to_not have_content("Shelter Network")
    expect(page).to have_content("San Mateo County Human Services Agency")

    # check filter settings
    expect(all(:css,"#location-options .current-option label").last).to have_content("All")
    expect(all(:css,"#service-area-options .current-option label").last).to have_content("All")
    expect(all(:css,"#kind-options .current-option label").last).to have_content("Human Services")
    expect(all(:css,"#org-name-options .current-option label").last).to have_content("All")
  end


end