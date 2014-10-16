require 'rails_helper'

feature 'location details' do

  context 'when the details page is visited via search results', :vcr do
    it 'includes address elements' do
      search_for_example
      visit_details
      expect(page).to have_content('Mailing Address')
      expect(page).to have_content('Physical Address')
      expect(page).to have_content('2013 Avenue of the fellows')
      expect(page).to have_content('90210')
      expect(page).to have_content('94103')
    end
  end

  context 'when you return to the results page from details page', :js, :vcr do
    it 'displays the same search results' do
      search_for_example
      visit_details
      find_link('referrals@example.com')
      find_link('a', text: 'Back').click
      expect(page).to have_selector('#list-view')
      expect(page.find('.agency')).to have_link('Example Agency')
    end
  end

  scenario 'when the details page is visited directly', :vcr do
    visit_test_location
    expect(page).to have_content('2013 Avenue of the fellows')
  end

  context 'when the details page is visited directly with invalid id', :vcr do
    it 'redirects to the homepage' do
      visit('/locations/foobar')
      expect(current_path).to eq(root_path)
    end

    it 'displays an error message' do
      visit('/locations/foobar')
      expect(page).to have_content('Sorry, that page does not exist')
    end
  end

  context 'when URL to details page contains quote at the end', :vcr do
    it 'redirects to the homepage' do
      visit("/locations/foobar'")
      expect(current_path).to eq(root_path)
    end

    it 'displays a not found error message' do
      visit("/locations/foobar'")
      expect(page).to have_content('Sorry, that page does not exist')
    end
  end

  context 'when phone elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes the section header' do
      expect(page).to have_content('General Contact Info')
    end

    it 'includes the phone number, type, and department' do
      expect(page).to have_content('(650) 627-8244 fax Reservations')
    end

    it 'includes the phone number, extension, type, and department' do
      expect(page).to have_content('(650) 372-6200 x 123 voice Information')
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

    it 'includes wait estimate info' do
      expect(page).to have_content('No wait to 2 weeks')
    end

    it 'includes service areas info' do
      expect(page).to have_content('San Mateo County')
    end

    it 'includes updated time' do
      expect(page).to have_content('Monday, 20 October 2014 at 12:44 PM PDT')
    end

  end

  context 'when location elements are present' do
    before(:each) do
      cassette = 'location_details/when_the_details_page_is_visited_directly'
      VCR.use_cassette(cassette) do
        visit_test_location
      end
    end

    it 'includes short description' do
      within '.short-desc' do
        expect(page).
          to have_content('[NOTE THIS IS NOT A REAL ENTRY--')
      end
    end

    it 'includes description' do
      expect(page).to have_content('Lorem ipsum')
    end

    it 'includes transporation info' do
      expect(page).to have_content('SAMTRANS stops within 1 block')
    end

    it 'includes hours info' do
      expect(page).to have_content('Monday-Friday, 8-5; Saturday, 10-6;')
    end

    it 'includes languages info' do
      expect(page).to have_content('Cantonese')
    end

    it 'includes accessibility info' do
      expect(page).to have_content('Disabled Parking')
    end

    it 'includes email info' do
      expect(page).to have_link('info@example.com')
    end

    it 'includes URLs' do
      expect(page).to have_link('www.smchealth.org')
    end

    it 'includes Physical Address info' do
      expect(page).to have_content('Avenue of the fellows')
    end

    it 'includes Mailing Address info' do
      expect(page).to have_content('The Foodies')
    end

    xit 'includes keywords' do
      expect(page).to have_link('Ruby on Rails/MongoDB/Redis')
    end

    it 'sets the page title to the location name + site title' do
      expect(page).to have_title('Example Location | Ohana Web Search')
    end
  end

  context 'when Contact elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
        visit_test_location
      end
    end

    it 'includes the contact section header' do
      expect(page).to have_content('Specific Contact')
    end

    it 'includes contact name' do
      expect(page).to have_content('Suzanne Badenhoop')
    end

    it 'includes contact title and department' do
      within('#contact-info > section:nth-child(2)') do
        expect(page).to have_content('Board President, Referrals')
      end
    end

    it 'includes contact phone number, type, and department' do
      expect(page).to have_content('(202) 555-1212 fax Referrals')
    end

    it 'includes contact phone number, extension, type, and department' do
      expect(page).to have_content('(123) 456-7890 x 1200 voice Referrals')
    end

    it 'includes contact email' do
      expect(page).to have_content('suzanne@example.com')
    end
  end

  scenario 'when Contact only includes department', :vcr do
    visit('/locations/admin-test-org/admin-test-location')
    within('#contact-info .contact-box-specific') do
      expect(page).to have_content('Office of Innovation')
      expect(page).to_not have_selector('contact-title')
    end
  end

  scenario 'when Contact only includes title', :vcr do
    visit('/locations/peninsula-family-service/fair-oaks-adult-activity-center')
    within('#contact-info') do
      expect(page).to have_content('Director of Older Adult Services')
      expect(page).to_not have_selector('contact-department')
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
        to have_link('Edit', href: "#{admin_site}/locations/example-location")
    end

    it 'includes rel=nofollow' do
      within '.updated-at' do
        expect(find(:rel, 'nofollow')).to be_present
      end
    end
  end
end
