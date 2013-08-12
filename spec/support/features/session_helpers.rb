module Features
  module SessionHelpers

    # search helpers
    def search(options = {})
      keyword = options[:keyword] || ''
      location = options[:location] || ''
      fill_in('keyword', :with => keyword)
      fill_in('location', :with => location)
      click_button 'Find'
    end

    def search_from_home(options = {})
      visit ("/")
      search(options)
    end

    # navigation helpers
    def visit_details
      #page.find(:css, '#list-view li:first-child a').click
      page.find("#list-view").first(:css, 'a').click
    end

    def looks_like_results
      expect(page).to have_content("SanMaceo Example Agency")
      expect(page).to have_content("Showing 1 of 1 result")
      expect(page).to have_title "Showing 1 of 1 result"
    end

    def looks_like_puente
      expect(page).to have_content("Puente Resource Center")
      expect(page).to have_content("Showing 1 of 1 result")
      expect(page).to have_title "Showing 1 of 1 result"
    end

    def looks_like_no_results
      expect(page).to have_content("Education")
      expect(page).to have_content("your search returned no results.")
      expect(page).to have_content("Showing 0 of 0 results")
    end

    def looks_like_details
      find(:css, "#detail-info .description a").should have_content("more")
      find(:css, "#detail-info .description a").click
      find(:css, "#detail-info .description a").should have_content("less")

      expect(page).to have_title "Gimme 1 2 3 | OhanaSMC"

      within ("#detail-info .payments-accepted") do
        page.should_not have_content("Women, Infants, and Children")
        find(:css, ".popup-term", :text=>"WIC").trigger(:mousedown)
        page.should have_content("Women, Infants, and Children")
      end
      expect(page).to have_content("Works to control")
      expect(page).to have_content("Profit and nonprofit")
      expect(page).to have_content("Marin County")
      expect(page).to have_content("Walk in")
      expect(page).to have_content("permits and photocopying")
      expect(page).to have_content("Russian")
      expect(page).to have_content("Special parking")
      expect(page).to have_content("Map data")
    end

    def looks_like_homepage
      expect(page).to have_title "OhanaSMC"
      expect(page).to have_content "About"
      expect(page).to have_content "Contribute"
      expect(page).to have_content "Feedback"
      expect(page).to have_content "Emergency"
      expect(page).to have_content "Food"
      expect(page).to have_content "I need"
      expect(page).to have_content "I am near"
    end

    def looks_like_homepage_as_user_sees_it
      expect(page).to have_title "OhanaSMC"
      expect(page).to have_content "I need"
      expect(page).to have_button "Find"
      expect(page).to_not have_title "Showing 1 of 1 result"
    end

    # webbrowser navigation using requirejs
    def go_back
      page.evaluate_script("window.history.back()")
    end

    def go_forward
      page.evaluate_script("window.history.forward()")
    end

    # helper to (hopefully) wait for page to load
    def delay
      sleep(1)
    end

  end
end