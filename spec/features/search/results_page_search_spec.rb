require 'rails_helper'

feature 'searching from results page', :vcr do
  before { visit('/locations') }

  context 'when search returns results' do
    before { search(keyword: 'lorem') }

    it 'displays the name of the agency as a link' do
      expect(page).to have_link('Example Agency')
    end

    it 'displays the name of the location as a link' do
      location_url = '/locations/example-agency/' \
                     'example-location?keyword=lorem&' \
                     'location=&org_name=&utf8=%E2%9C%93'
      expect(page).to have_link('Example Location', href: location_url)
    end

    it 'displays the location phone number' do
      expect(page).to have_content('(650) 372-6200')
      expect(page).not_to have_content('(650) 372-6200 x 123 voice Information')
    end

    it 'displays the location phone extension' do
      expect(page).to have_content('x 123')
    end

    it 'displays the location physical address' do
      address = '2013 Avenue of the fellows, Suite 100, San Francisco, CA 94103'
      expect(page).to have_content(address)
    end

    it 'displays the location short description' do
      expect(page).to have_content('[NOTE THIS IS NOT A REAL ENTRY')
    end

    it 'displays the number of results' do
      expect(page).to have_content('Displaying 1 - 1 of 2 results')
    end

    it 'includes the results info in the page title' do
      expect(page).
        to have_title 'Search results for: keyword: lorem | SMC-Connect'
    end

    it 'populates the keyword field with the search term' do
      expect(find_field('keyword').value).to eq('lorem')
    end
  end

  context 'when search returns no results' do
    before { search(location: '22031') }

    it 'displays a helpful error message' do
      expect(page).
        to have_content('Unfortunately, your search returned no results.')
    end

    it 'does not include the map canvas' do
      expect(page).not_to have_selector('#map-canvas')
    end

    it 'includes the .no-results selector' do
      expect(page).to have_selector('.no-results')
    end

    it 'includes the homepage links' do
      expect(page).to have_link 'Health Insurance'
    end
  end

  it 'allows searching for a location' do
    search(location: '94403')
    expect(page).to have_content('Hillsdale Community Library')
  end

  it 'allows searching for an agency name' do
    search(org_name: 'samaritan')
    expect(page).to have_link('Samaritan House')
  end

  it 'allows searching for both keyword and location' do
    search(keyword: 'clinic', location: '94403')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  it 'allows searching for both keyword and agency name' do
    search(keyword: 'clinic', org_name: 'samaritan')
    expect(page).to have_link('Redwood City Free Medical Clinic')
  end

  it 'allows searching for both location and agency name' do
    search(location: '94403', org_name: 'samaritan')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  it 'allows searching for keyword, location, and agency name' do
    search(keyword: 'clinic', location: '94403', org_name: 'samaritan')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  context 'when clicking organization link in results' do
    it 'displays locations that belong to that organization' do
      search(keyword: 'Samaritan House')
      first('#list-view li').click_link('Samaritan House')
      expect(page).to have_link('Redwood City Free Medical Clinic')
    end
  end

  scenario 'when click Kind link' do
    visit('/locations?keyword=soccer')
    page.first('a', text: 'Other').click
    expect(find('#list-view')).not_to have_content('Sports')
  end

  context 'when organization detail box is shown' do
    before { search(org_name: 'Example Agency') }
    it 'displays organization name in detail box' do
      expect(find('.organization-detail')).to have_content('Example Agency')
    end

    it 'displays organization alternative name' do
      expect(find('.organization-detail')).to have_content('(Alternate Agency Name)')
    end

    it 'displays organization website address' do
      expect(find('.organization-detail')).to have_content('example.org')
    end

    it 'displays organization email address' do
      expect(find('.organization-detail')).to have_content('info@example.org')
    end

    it 'displays organization incorporation date' do
      expect(find('.organization-detail')).to have_content('Incorporated 1970')
    end

    it 'displays organization accreditation list' do
      expect(find('.organization-detail')).to have_content('BBB')
    end

    it 'displays organization licenses list' do
      expect(find('.organization-detail')).to have_content('State Board')
    end
  end

  context 'when a search parameter has no value' do
    it 'is not included in the page title' do
      visit('/locations?location=94403&keyword=')
      expect(page).
        to have_title('Search results for: location: 94403 | SMC-Connect')
    end
  end

  context 'when multiple search parameters have values' do
    it 'they are all included in the page title' do
      visit('/locations?location=94403&keyword=foo')
      expect(page).
        to have_title('location: 94403, keyword: foo | SMC-Connect')
    end
  end

  context 'when search contains invalid parameters' do
    it 'displays a helpful error message' do
      visit '/locations?location=94403&radius=foo'
      expect(page).
        to have_content('That search was improperly formatted.')
    end
  end

  context 'when clicking the clear button for keyword', :js do
    it 'clears the contents of the keyword field' do
      search(keyword: 'clinic')
      find('#keyword-search-box').find('.button-clear').click
      expect(find_field('keyword').value).to eq ''
    end
  end

  context 'when clicking the clear button for location', :js do
    it 'clears the contents of the location field' do
      search(location: '94403')
      find('#location-options').find('.button-clear').click
      expect(find_field('location').value).to eq ''
    end
  end

  context 'when clicking the clear button for agency', :js do
    it 'clears the contents of the agency field' do
      search(org_name: 'samaritan')
      find('#org-name-options').find('.button-clear').click
      expect(find_field('org_name').value).to eq ''
    end
  end
end
