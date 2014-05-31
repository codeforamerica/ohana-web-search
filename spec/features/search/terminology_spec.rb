require 'spec_helper'

feature "terminology search" do

  scenario 'with keyword that returns no terminology info box', :vcr do
    search_from_home(:keyword => 'asdfg')
    expect(page).not_to have_selector('#terminology')
  end

  scenario 'with keyword that returns terminology info box', :vcr do
    search_from_home(:keyword => 'wic')
    expect(page).to have_selector('#terminology')
    within('#terminology') do
      expect(page).to have_content('Women, Infants, and Children')
    end
  end

  scenario 'with synonym that returns terminology info box', :vcr do
    search_from_home(:keyword => 'Women, Infants, and Children')
    expect(page).to have_selector('#terminology')
    within('#terminology') do
      expect(page).to have_content('Women, Infants, and Children')
    end
  end

  scenario 'with keyword that returns custom terminology info box', :vcr do
    search_from_home(:keyword => 'health care reform')
    expect(page).to have_selector('#terminology')
    within('#terminology') do
      expect(page).to have_selector('table')
    end
  end

end
