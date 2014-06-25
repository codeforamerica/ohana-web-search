require 'spec_helper'

feature "results page search", :js, :vcr do

  background do
    page.set_rack_session('aggregate_locations' => [])
    page.set_rack_session('aggregate_org_names' => [])
    search_from_home(:keyword=>"asdfg")
  end

  context 'when location filter has no cached values and legend is toggled' do
    it "displays the 'All' checkbox by default" do
      expect(find(:xpath, '//*[@id="location-toggle-group"]/label').text).
        to eq("All")
    end

    it "displays the 'Other...' checkbox when legend is expanded" do
      find(:xpath, '//*[@id="location-options"]/legend').click
      expect(find(:xpath, '//*[@id="location-option-1-label"]/span').text).
        to eq("Other...")
    end

    it "displays the 'All' checkbox when legend is collapsed" do
      # expand the legend first
      find(:xpath, '//*[@id="location-options"]/legend').click
      # click it again to collapse it
      find(:xpath, '//*[@id="location-options"]/legend').click

      expect(find(:xpath, '//*[@id="location-toggle-group"]/label').text).
        to eq("All")
    end
  end

  context 'when agency filter has no cached values and legend is toggled' do
    it "displays the 'All' checkbox by default" do
      expect(find(:xpath, '//*[@id="org-name-toggle-group"]/label').text).
        to eq("All")
    end

    it "displays the 'Other...' checkbox when legend is expanded" do
      find(:xpath, '//*[@id="org-name-options"]/legend').click
      expect(find(:xpath, '//*[@id="org-name-option-1-label"]/span').text).
        to eq("Other...")
    end

    it "displays the 'All' checkbox when legend is collapsed" do
      # expand the legend first
      find(:xpath, '//*[@id="org-name-options"]/legend').click
      # click it again to collapse it
      find(:xpath, '//*[@id="org-name-options"]/legend').click

      expect(find(:xpath, '//*[@id="org-name-toggle-group"]/label').text).
        to eq("All")
    end
  end

  context 'when location filter has no cached values and checkbox is toggled' do
    it "displays the 'All' checkbox when filter is collapsed via checkbox" do
      # Expand the filter first by clicking on the "All" checkbox
      find(:xpath, '//*[@id="location-toggle-group"]/div/div/i').click
      # Collapse the filter by clicking on the "All" checkbox again
      find(:xpath, '//*[@id="location-toggle-group-0"]/div/div/i').click

      expect(find(:xpath, '//*[@id="location-toggle-group"]/label').text).
        to eq("All")
    end
  end

  context 'when agency filter has no cached values and checkbox is toggled' do
    it "displays the 'All' checkbox when filter is collapsed via checkbox" do
      # Expand the filter first by clicking on the "All" checkbox
      find(:xpath, '//*[@id="org-name-toggle-group"]/div/div/i').click
      # Collapse the filter by clicking on the "All" checkbox again
      find(:xpath, '//*[@id="org-name-toggle-group-0"]/div/div/i').click

      expect(find(:xpath, '//*[@id="org-name-toggle-group"]/label').text).
        to eq("All")
    end
  end

  # test adding custom value to filters that accept custom values
  scenario 'when location filter has no cached values and custom value is added' do
    fill_in('keyword', with: '')
    set_custom_value("location", "location", "94403")
    all(".toggle-group-wrapper.add label").first.trigger("mousedown")
    expect(page).to have_content("6 results within 5 miles of '94403'")
  end

  scenario 'when agency filter has no cached values and custom value is added' do
    fill_in('keyword', with: '')
    set_custom_value("org-name", "org_name", "Salvation Army")
    all(".toggle-group-wrapper.add label").first.trigger("mousedown")
    expect(page).to have_content("4 results")
  end

  # test adding custom value to filters and retrieving no results
  scenario 'when location filter has custom value and no results' do
    set_custom_value("location", "location", "San Mateo, CA")
    find('#find-btn').click

    find(:xpath, '//*[@id="location-options"]/legend').click
    expect(find_by_id("location-option-input").value).to eq "San Mateo, CA"
  end

  scenario 'when agency filter has custom value and no results' do
    set_custom_value("org-name", "org_name", "United States Government")
    find('#find-btn').click

    find(:xpath, '//*[@id="org-name-options"]/legend').click
    expect(find_by_id("org-name-option-input").value).to eq "United States Government"
  end

  # test adding custom value to filters and retrieving results
  scenario 'when location filter has custom value and has results' do
    set_custom_value("location", "location", "San Mateo, CA")
    fill_in('keyword', :with => '')
    find('#find-btn').click

    find(:xpath, '//*[@id="location-options"]/legend').click
    expect(find(:xpath, '//*[@id="location-option-2-label"]').text).
      to eq('San Mateo, CA')
    expect(page).not_to have_css("location")
  end

  scenario 'when agency filter has custom value and has results' do
    set_custom_value("org-name", "org_name", "Salvation Army")
    fill_in('keyword', :with => '')
    find('#find-btn').click

    find(:xpath, '//*[@id="org-name-options"]/legend').click
    expect(find(:xpath, '//*[@id="org-name-option-2-label"]').text).
      to eq('Salvation Army')
    expect(page).not_to have_css("org_name")
  end

  # test filter selection across all filters
  scenario 'when location filter has cached values and new option is selected' do
    fill_in('keyword', :with => "")
    find('#find-btn').click
    select_existing_filter_option("location", "location", "Redwood City, CA")
    find('#find-btn').click

    expect(page).to have_content("12 results within 5 miles of 'Redwood City, CA'")
    expect(all("#location-options .current-option label").last).to have_content("Redwood City, CA")
  end

  scenario 'when agency filter has cached values and new option is selected' do
    fill_in('keyword', :with => '')
    find('#find-btn').click
    visit("/organizations?page=3")

    select_existing_filter_option("org-name", "org_name", "Peninsula Family Service")
    find('#find-btn').click

    expect(page).to have_content("5 results")
    expect(all("#org-name-options .current-option label").last).to have_content("Peninsula Family Service")
  end

  # user clicks filter links in results list
  scenario 'when clicking organization link in results' do
    search(:keyword => "Samaritan House")
    first("#list-view li").click_link("Samaritan House")
    expect(page).to have_content("Redwood City Free Medical Clinic")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("Samaritan House")
  end

  scenario 'when clicking the reset button' do
    expect(page).to have_content("No results")
    find_by_id("reset-btn").click

    # check filter settings
    expect(find_field("keyword").value).to eq ""
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("All")

    find('#find-btn').click
    expect(page).to have_content("22 results")
  end
end