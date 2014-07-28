require 'spec_helper'

feature 'location details' do

  context 'when the details page is visited via search results', :vcr do
    it 'includes address elements' do
      search_for_maceo
      visit_details
      expect(page).to have_content('Mailing Address')
      expect(page).to have_content('Physical Address')
      expect(page).to have_content('2013 Avenue of the fellows')
      expect(page).to have_content('90210')
      expect(page).to have_content('05201')
    end
  end

  context 'when you return to the results page from details page', :js, :vcr do
    it 'displays the same search results' do
      search_for_maceo
      visit_details
      find_link('maceo@parker.com')
      find_link('a', text: 'Back').click
      expect(page).to have_selector('#list-view')
      expect(page.find('.agency')).to have_link('SanMaceo Example Agency.')
    end
  end

  scenario 'when the details page is visited directly', :vcr do
    visit_test_location
    expect(page).to have_content('2013 Avenue of the fellows')
  end

  context 'when the details page is visited directly with invalid id', :vcr do
    it 'redirects to the homepage' do
      visit('/organizations/foobar')
      expect(current_path).to eq(root_path)
    end

    it 'displays an error message' do
      visit('/organizations/foobar')
      expect(page).to have_content('Sorry, that page does not exist')
    end
  end

  context 'when URL to details page contains quote at the end', :vcr do
    it 'redirects to the homepage' do
      visit("/organizations/foobar'")
      expect(current_path).to eq(root_path)
    end

    it 'displays an error message' do
      visit("/organizations/foobar'")
      expect(page).to have_content('Please remove the single quote')
    end
  end

  context 'when phone elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes the Contact header' do
      expect(page).to have_content('Contact')
    end

    it 'includes the department and phone type' do
      expect(page).to have_content('(650) 372-6200 TTY Information')
    end

    it 'includes the Fax number' do
      expect(page).to have_content('(650) 627-8244')
    end

    it 'specifies TTY numbers' do
      expect(page).to have_content('(650) 372-6200 TTY')
    end

  end

  context 'when service elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes eligibility info' do
      expect(page).to have_content('None')
    end

    it 'includes audience info' do
      expect(page).to have_content('Profit and nonprofit businesses')
    end

    it 'includes fees info' do
      expect(page).to have_content('permits and photocopying')
    end

    it 'includes hours info' do
      expect(page).to have_content('Monday-Friday, 8-5; Saturday, 10-6;')
    end

    it 'includes how to apply info' do
      expect(page).to have_content('Walk in or apply by phone or mail')
    end

    # Wait time not included in the view.
    # Till we have a consistent meaning for wait time
    # it's best left out of the front-end view
    xit 'includes wait info' do
      expect(page).to have_content('No wait to 2 weeks')
    end

    # Service areas not included in view.
    # Best to leave this out of the view, this is data that could easily be
    # wrong and it's better that the client contact the agency and ask for
    # services and be referred accordingly vs. going off this list.
    xit 'includes service areas' do
      expect(page).to have_content('Marin County')
    end

    it 'includes updated time' do
      expect(page).to have_content('Thursday, 22 May 2014 at 5:31 PM PDT')
    end

  end

  context 'when location elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes URLs' do
      expect(page).to have_link('www.smchealth.org')
    end

    it 'includes accessibility info' do
      expect(page).to have_content('Disabled Parking')
    end

    # Contact is not included because we have an ask_for field already
    xit 'includes Contact info' do
      expect(page).to have_content('Suzanne Badenhoop')
    end

    it 'includes email info' do
      expect(page).to have_link('sanmaceo@co.sanmaceo.ca.us')
    end

    it 'includes hours info' do
      expect(page).to have_content('Monday-Friday, 8-5; Saturday, 10-6;')
    end

    it 'includes languages info' do
      expect(page).to have_content('Chinese (Cantonese)')
    end

    it 'includes Mailing Address info' do
      expect(page).to have_content('Hella Fellas')
    end

    it 'includes description' do
      expect(page).to have_content('Lorem ipsum')
    end

    it 'includes short description' do
      within '.short-desc' do
        expect(page).
          to have_content('[NOTE THIS IS NOT A REAL ENTRY--')
      end
    end

    it 'includes transporation info' do
      expect(page).to have_content('SAMTRANS stops within 1 block')
    end

    it 'sets the page title to the location name + site title' do
      expect(page).to have_title('San Maceo Agency | Ohana Web Search')
    end
  end

  describe 'Edit link' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'points to the corresponding location in the admin site' do
      admin_site = 'http://ohana-api-demo.herokuapp.com/admin'
      expect(page).
        to have_link('Edit', href: "#{admin_site}/locations/san-maceo-agency")
    end
  end
end
