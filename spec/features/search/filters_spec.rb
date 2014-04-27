require 'spec_helper'

feature "results page search", :js, :vcr do

  background do
    page.set_rack_session('aggregate_locations' => [])
    page.set_rack_session('aggregate_org_names' => [])
    search_from_home(:keyword=>"asdfg")
  end

  # test filter fieldset legend toggling across all filters
  scenario 'when location filter has no cached values and legend is toggled' do
    test_filter_legend("location")
  end

  scenario 'when service-area filter has no cached values and legend is toggled' do
    test_filter_legend("service-area")
  end

  scenario 'when agency filter has no cached values and legend is toggled' do
    test_filter_legend("org-name")
  end

  # test filter fieldset toggle toggling across all filters
  scenario 'when location filter has no cached values and toggle is toggled' do
    find(".require-loaded")
    within("#location-options") do
      # Click on the "All" checkbox
      all(".current-option label").last.click
      # Click on the "All" checkbox again
      find(".options label",:text => "All").click
      expect(all(".current-option label").last).to have_content("All")
    end
  end

  scenario 'when service-area filter has no cached values and toggle is toggled' do
    find(".require-loaded")
    within("#service-area-options") do
      # Click on the "All" checkbox
      # Search from home page does not use service_area filter
      all(".current-option label").last.click
      # Click on the "San Mateo County, CA" checkbox
      find('label', :text => 'San Mateo County, CA').click
      # Click on the "San Mateo County, CA" checkbox again
      find('label', :text => 'San Mateo County, CA').click
      expect(all(".current-option label").last).to have_content("San Mateo County, CA")
    end
  end

  scenario 'when agency filter has no cached values and toggle is toggled' do
    find(".require-loaded")
    within("#org-name-options") do
      # Click on the "All" checkbox
      all(".current-option label").last.click
      # Click on the "All" checkbox again
      find(".options label",:text => "All").click
      expect(all(".current-option label").last).to have_content("All")
    end
  end

  # test adding custom value to filters that accept custom values
  scenario 'when location filter has no cached values and custom value is added' do
    fill_filter_custom_field("location","Custom Value")
    expect(all("#location-options .current-option label").last).to have_content("Custom Value")
  end

  scenario 'when agency filter has no cached values and custom value is added' do
    fill_filter_custom_field("org-name","Custom Value")
    expect(all("#org-name-options .current-option label").last).to have_content("Custom Value")
  end

  # test adding custom value to filters and retrieving no results
  scenario 'when location filter has custom value and no results' do
    test_filter_custom_value_no_results("location","San Mateo, CA")
  end

  scenario 'when agency filter has custom value and no results' do
    test_filter_custom_value_no_results("org-name","United States Government")
  end

  # test adding custom value to filters and retrieving results
  scenario 'when location filter has custom value and has results' do
    name = "location"
    field = "San Mateo, CA"
    set_filter(name,field)
    fill_in('keyword', :with => '') # clear keyword

    find('#find-btn').click

    find(".require-loaded")
    within("##{name}-options") do
      find(".closed").click
      expect(page).to have_selector(".open")
      expect(find(".available-options")).to have_css(".toggle-group", :count=>3)
      expect(page).not_to have_css("##{name}-option-input")
    end
  end

  scenario 'when agency filter has custom value and has results' do
    name = "org-name"
    field = "Samaritan House"
    set_filter(name,field)
    fill_in('keyword', :with => '') # clear keyword

    find('#find-btn').click

    find(".require-loaded")
    within("##{name}-options") do
      find(".closed").click
      expect(page).to have_selector(".open")
      expect(find(".available-options")).to have_css(".toggle-group", :count=>3)
      expect(page).not_to have_css("##{name}-option-input")
    end
  end

  # test filter selection across all filters
  scenario 'when location filter has cached values and new option is selected' do
    fill_in('keyword', :with => "") # clear keyword
    find('#find-btn').click
    expect(page).to have_content("22 results")
    set_filter("location","fairfax, va",true)
    find('#find-btn').click
    expect(page).to have_content("No results within 5 miles of 'fairfax, va'")
    expect(all("#location-options .current-option label").last).to have_content("fairfax, va")
  end

  scenario 'when service-area filter has cached values and new option is selected' do
    fill_in('keyword', :with => '') # clear keyword
    find('#find-btn').click
    expect(page).to have_content("22 results")
    set_filter("service-area","All",false)
    find('#find-btn').click
    expect(page).to have_content("22 results")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
  end

  scenario 'when agency filter has cached values and new option is selected' do
    fill_in('keyword', :with => '') # clear keyword
    find('#find-btn').click
    expect(page).to have_content("22 results")
    visit("/organizations?page=3")
    within(".require-loaded") do
      within("#org-name-options") do
        find(".closed").click
        find(".toggle-group", :text => "SanMaceo Example Agency").click
      end
    end
    find('#find-btn').click
    expect(page).to have_content("1 result")
    expect(all("#org-name-options .current-option label").last).to have_content("SanMaceo Example Agency")
  end

  # user clicks filter links in results list
  scenario 'when clicking organization link in results' do
    search(:keyword => "Samaritan House")
    first("#list-view li").click_link("Samaritan House")
    expect(page).to have_content("San Mateo Free Medical Clinic")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("Samaritan House")
  end

  scenario 'when clicking the reset button' do
    expect(page).to have_content("No results")
    #find_button("Clear filters").click
    all(".reset-btn").first.click
    # check filter settings
    expect(find_field("keyword").value).to eq ""
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("All")

    find('#find-btn').click
    expect(page).to have_content("22 results")
  end

end