require 'spec_helper'

feature "results page search", :js=>true do

  background do
    page.set_rack_session('aggregate_locations' => [])
    search_from_home(:keyword=>"asdfg")
  end

  # test filter fieldset legend toggling across all filters
  scenario 'when location filter has no cached values and legend is toggled', :vcr do
    test_filter_legend("location")
  end
  scenario 'when service-area filter has no cached values and legend is toggled', :vcr do
    test_filter_legend("service-area","San Mateo County, CA")
  end
  scenario 'when kind filter has no cached values and legend is toggled', :vcr do
    test_filter_legend("kind", "Human Services",13)
  end
  scenario 'when agency filter has no cached values and legend is toggled', :vcr do
    test_filter_legend("org-name")
  end

  # test filter fieldset toggle toggling across all filters
  scenario 'when location filter has no cached values and toggle is toggled', :vcr do
    test_filter_toggle("location")
  end
  scenario 'when service-area filter has no cached values and toggle is toggled', :vcr do
    test_filter_toggle("service-area","San Mateo County, CA")
  end
  scenario 'when kind filter has no cached values and toggle is toggled', :vcr do
    test_filter_toggle("kind", "Human Services",13)
  end
  scenario 'when agency filter has no cached values and toggle is toggled', :vcr do
    test_filter_toggle("org-name")
  end

  # test adding custom value to filters that accept custom values
  scenario 'when location filter has no cached values and custom value is added', :vcr do
    test_filter_custom_value("location")
  end
  scenario 'when agency filter has no cached values and custom value is added', :vcr do
    test_filter_custom_value("org-name")
  end

  # test adding custom value to filters and retrieving no results
  scenario 'when location filter has custom value and no results', :vcr do
    test_filter_custom_value_no_results("location","San Mateo, CA")
  end
  scenario 'when agency filter has custom value and no results', :vcr do
    test_filter_custom_value_no_results("org-name","United States Government")
  end

  # test adding custom value to filters and retrieving results
  scenario 'when location filter has custom value and has results', :vcr do
    name = "location"
    field = "San Mateo, CA"
    set_filter(name,field)
    fill_in('keyword', :with => '') # clear keyword

    find('#update-btn').click

    find(".require-loaded")
    within("##{name}-options") do
      find(".closed").click
      page.should have_selector(".open")
      find(".available-options").should have_css(".toggle-group", :count=>3)
      page.should_not have_css("##{name}-option-input")
    end
  end
  scenario 'when agency filter has custom value and has results', :vcr do
    name = "org-name"
    field = "United States Government"
    set_filter(name,field)
    fill_in('keyword', :with => '') # clear keyword

    find('#update-btn').click

    find(".require-loaded")
    within("##{name}-options") do
      find(".closed").click
      page.should have_selector(".open")
      find(".available-options").should have_css(".toggle-group", :count=>3)
      page.should_not have_css("##{name}-option-input")
    end
  end

  # test filter selection across all filters
  scenario 'when location filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    find('#update-btn').click
    set_filter("location","San Francisco, CA",false)
    find('#update-btn').click
    expect(all("#location-options .current-option label").last).to have_content("San Francisco, CA")
  end
  scenario 'when service-area filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    find('#update-btn').click
    page.should have_content("590 results")
    set_filter("service-area","All",false)
    find('#update-btn').click
    page.should have_content("679 results")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
  end
  scenario 'when kind filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    find('#update-btn').click
    set_filter("kind","Other",false)
    find('#update-btn').click
    expect(all("#kind-options .current-option label").last).to have_content("Other")
  end
  scenario 'when agency filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    find('#update-btn').click
    set_filter("org-name","San Mateo County Human Services Agency",false)
    find('#update-btn').click
    expect(all("#org-name-options .current-option label").last).to have_content("San Mateo County Human Services Agency")
  end


  # user clicks filter links in results list
  scenario 'when clicking organization link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    page.should have_content("St. Vincent de Paul Society")
    first("#list-view li").click_link("St. Vincent de Paul Society")
    page.should_not have_content("Shelter Network")
    page.should have_content("San Mateo Homeless Help Center")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("St. Vincent de Paul Society")
  end

  scenario 'when clicking kind link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    page.should have_content("St. Vincent de Paul Society")
    first("#list-view li").click_link("Human Services")
    expect(page).to_not have_content("Shelter Network")
    expect(page).to have_content("San Mateo County Human Services Agency")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("Human Services")
    expect(all("#org-name-options .current-option label").last).to have_content("All")
  end

end