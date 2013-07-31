module Features
  module SessionHelpers
    
    # search helpers
    def search(options = {})
      path = options[:path] || ''
      keyword = options[:keyword] || ''
      location = options[:location] || ''

      visit(path) if path.present?
      delay
      fill_in('keyword', :with => keyword) if keyword.present?
      fill_in('location', :with => location) if location.present?
      click_button 'Find'
      looks_like_results
    end

    # navigation helpers
    def visit_details
      looks_like_results_list
      page.find(:css, '#list-view li:first-child a').click
    end

    # webbrowser navigation using requirejs
    def back_button_pressed
      wait_for_requirejs
      page.execute_script("window.history.back();")
    end

    def forward_button_pressed
      wait_for_requirejs
      page.execute_script("window.history.forward();")
    end

    # helper to wait for requirejs to load before proceeding
    def wait_for_requirejs
      page.find(:css, ".require-loaded")
    end

    # helper to (hopefully) wait for page to load
    def delay
      sleep(1)
    end

    # check for distinctive features of pages
    def looks_like_homepage
      delay
      within ( ".home main" ) do
        expect(page).to have_title "OhanaSMC"
        expect(page).to have_css("#search-container")
        expect(page).to_not have_css("#results-container")
      end
    end

    def looks_like_results
      delay
      within ( ".inside main" ) do
        expect(page).to have_css("#search-container")
        expect(page).to have_css("#results-entries")
      end
    end

    def looks_like_results_list
      delay
      within ( ".inside main" ) do
        expect(page).to have_css("#search-container")
        expect(page).to have_css("#list-view")
      end
    end

    def looks_like_details(title)
      delay
      within ( ".inside main" ) do
        expect(page).to have_title "#{title} | OhanaSMC"
        expect(page).to have_css("#search-container")
        expect(page).to have_css("#detail-info")
      end
    end

    def looks_like_about
      delay
      within ( ".inside main" ) do
        expect(page).to have_title "About | OhanaSMC"
        expect(page).to have_css("#about-box")
        expect(page).to have_css("#contribute-box")
        expect(page).to have_css("#feedback-box")
      end
    end

    def looks_like_invalid_search(options = {})      
      keyword = options[:keyword] || ''
      location = options[:location] || ''

      within ("#results-container header") do
        expect(page).
          to have_content("Showing 0 of 0 results matching '#{keyword}'") if keyword.present?

        expect(page).
          to have_content("Showing 0 of 0 results within 2 miles of '#{location}'") if location.present?

        expect(page).
          to have_content("Showing 0 of 0 results matching '#{keyword}' within 2 miles of '#{location}'") if keyword.present? && location.present?
      end

      find_field("keyword").value.should == "#{keyword}" if keyword.present?
      find_field("location").value.should == "#{location}" if location.present?
    end

  end
end