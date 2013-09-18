module Features
  module SessionHelpers

    # search helpers
    def search(options = {})
      keyword = options[:keyword]
      location = options[:location]
      fill_in('keyword', :with => keyword)
      if options[:on_home].present?
        fill_in('location', :with => location, :visible => false)
        find(:css, '#find-btn').click
      else
        fill_in('location', :with => location)
        find(:css, '#update-btn').click
      end
    end

    def search_by_language(lang)
      fill_in('keyword', :with => "care")
      select(lang, :from => 'language', :exact => true)
      find(:css, '#update-btn').click
    end

    def search_from_home(options = {})
      visit ("/")
      options[:on_home] = true
      search(options)
    end

    # navigation helpers
    def visit_details
      page.find("#list-view").first(:css, 'a').trigger('click')
    end

    def looks_like_results
      expect(page).to have_content("SanMaceo Example Agency")
      expect(page).to have_content("1 result")
      expect(page).to have_title "1 result"
    end

    def looks_like_puente
      expect(page).to have_content("Puente Resource Center")
      expect(page).to have_content("1 result")
      expect(page).to have_title "1 result"
    end

    def looks_like_no_results
      expect(page).to have_selector(".no-results")
      expect(page).to have_content("your search returned no results.")
      expect(page).to have_selector("#search-summary")
      expect(page).to_not have_selector('#map-canvas')
    end

    def looks_like_location
      find(:css, "#detail-info .description a").should have_content("more")
      find(:css, "#detail-info .description a").click
      find(:css, "#detail-info .description a").should have_content("less")

      expect(page).to have_title "San Maceo Agency | SMC-Connect"

      expect(page).to have_content("Works to control")
      expect(page).to have_content("Profit and nonprofit")
      expect(page).to have_content("Marin County")
      expect(page).to have_content("Walk in")
      expect(page).to have_content("permits and photocopying")
      expect(page).to have_content("Russian")
      expect(page).to have_content("Special parking")
      expect(page).to have_link("Print")
      expect(page).to have_link("Directions")
    end

    def looks_like_market
      find(:css, "#detail-info .description a").should have_content("more")
      find(:css, "#detail-info .description a").click
      find(:css, "#detail-info .description a").should have_content("less")

      expect(page).to have_title "San Maceo Agency | SMC-Connect"

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
      expect(page).to have_link("Print")
      expect(page).to have_link("Directions")
    end

    def looks_like_homepage
      expect(page).to have_title "SMC-Connect"
      expect(page).to have_content "About"
      expect(page).to have_content "Contribute"
      expect(page).to have_content "Feedback"
      expect(page).to have_content "I need"
      expect(page).to have_content "I am near"
      expect(page).to have_content "reporting"
      expect(page).to have_content "government assistance"
    end

    def looks_like_homepage_as_user_sees_it
      expect(page).to have_title "SMC-Connect"
      expect(page).to have_content "I need"
      find("#language-box").should have_content("English")
      expect(page).to have_selector('#find-btn')
      expect(page).to_not have_title "1 result"
    end

    def go_to_next_page
      first('.pagination').find_link('>').click
    end

    def go_to_prev_page
      first('.pagination').find_link('<').click
    end

    def go_to_page(page)
      first('.pagination').find_link(page).click
    end

    # webbrowser navigation using browser's JS history API
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