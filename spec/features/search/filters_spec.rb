require 'spec_helper'

feature "results page search", :js do

  background do
    page.set_rack_session('aggregate_locations' => [])
    search_from_home(keyword: 'asdfg')
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
    fill_in('keyword', with: '')
    set_filter("location", "location", "94403")
    all(".toggle-group-wrapper.add label").first.trigger("mousedown")
    expect(page).to have_content("41 results within 5 miles of '94403'")
  end

  scenario 'when agency filter has no cached values and custom value is added', :vcr do
    fill_in('keyword', with: '')
    set_filter("org-name", "org_name", "vincent")
    all(".toggle-group-wrapper.add label").first.trigger("mousedown")
    expect(page).to have_content("4 results")
  end

  # test adding custom value to filters and retrieving no results
  scenario 'when location filter has custom value and no results', :vcr do
    set_filter("location", "location", "San Mateo, CA")
    find('#find-btn').click

    within("#location-options") do
      find(".closed").trigger('mousedown')
      expect(page).to have_selector(".open")
      expect(find(".available-options")).to have_css(".toggle-group", :count => 2)
      expect(find_field("location").value).to eq "San Mateo, CA"
    end
  end

  scenario 'when agency filter has custom value and no results', :vcr do
    set_filter("org-name", "org_name", "United States Government")
    find('#find-btn').click

    within("#org-name-options") do
      find(".closed").trigger('mousedown')
      expect(page).to have_selector(".open")
      expect(find(".available-options")).to have_css(".toggle-group", :count => 2)
      expect(find_field("org_name").value).to eq "United States Government"
    end
  end

  # test adding custom value to filters and retrieving results
  scenario 'when location filter has custom value and has results', :vcr do
    set_filter("location", "location", "San Mateo, CA")
    fill_in('keyword', :with => '') # clear keyword

    find('#find-btn').click

    find(".require-loaded")
    within("#location-options") do
      find(".closed").click
      expect(page).to have_selector(".open")
      expect(find(".available-options")).to have_css(".toggle-group", :count=>3)
      expect(page).not_to have_css("location")
    end
  end

  scenario 'when agency filter has custom value and has results', :vcr do
    set_filter("org-name", "org_name", "United States Government")
    fill_in('keyword', :with => '') # clear keyword

    find('#find-btn').click

    find(".require-loaded")
    within("#org-name-options") do
      find(".closed").click
      expect(page).to have_selector(".open")
      expect(find(".available-options")).to have_css(".toggle-group", :count=>3)
      expect(page).not_to have_css("org_name")
    end
  end

  # test filter selection across all filters
  scenario 'when location filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    find('#find-btn').click
    set_filter("location", "location", "San Mateo, CA", false)
    find('#find-btn').click
    expect(page).to have_content("40 results")
    expect(all("#location-options .current-option label").last).to have_content("San Mateo, CA")
  end

  scenario 'when service-area filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    set_filter("service-area", "service_area", "All", false)
    find('#find-btn').click
    expect(page).to have_content("130 results")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
  end

  scenario 'when kind filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    set_filter("kind", "kind", "Other", false)
    find('#find-btn').click
    expect(page).to have_content("35 results")
    expect(all("#kind-options .current-option label").last).to have_content("Other")
  end

  scenario 'when agency filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    find('#find-btn').click
    set_filter("org-name", "org_name", "San Mateo County Human Services Agency", false)
    find('#find-btn').click
    expect(page).to have_content("11 results")
    expect(all("#org-name-options .current-option label").last).to have_content("San Mateo County Human Services Agency")
  end


  # user clicks filter links in results list
  scenario 'when clicking organization link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    expect(page).to have_content("St. Vincent de Paul Society")
    first("#list-view li").click_link("St. Vincent de Paul Society")
    expect(page).not_to have_content("Shelter Network")
    expect(page).to have_content("San Mateo Homeless Help Center")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("St. Vincent de Paul Society")
  end

  scenario 'when clicking kind link in results', :vcr do
    search(:keyword => "St. Vincent de Paul Society")
    expect(page).to have_content("St. Vincent de Paul Society")
    first("#list-view li").click_link("Human Services")
    expect(page).not_to have_content("Shelter Network")
    expect(page).to have_content("San Mateo County Human Services Agency")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("Human Services")
    expect(all("#org-name-options .current-option label").last).to have_content("All")
  end

  scenario 'when clicking the reset button', :vcr do
    expect(page).to have_content("No results")
    all(".reset-btn").first.click

    # check filter settings
    expect(find_field("keyword").value).to eq ""
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("All")

    find('#find-btn').click
    expect(page).to have_content("339 results")
  end
end
