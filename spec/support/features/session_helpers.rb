module Features
  module SessionHelpers

    # page navigation helpers
    def visit_homepage_direct
      visit ('/')
    end

    def visit_results_page_direct
      visit ('/organizations')
    end

    def visit_about_page_direct
      visit ('/about')
    end

    # search helpers
    def search_for_both(address, distance)
      visit_homepage_direct
      fill_in('location', :with => address)
      select(distance, :from => 'miles')
      click_button 'Find'
    end

    def search_for_address(address)
      visit_homepage_direct
      fill_in('location', :with => address)
      click_button 'Find'
    end

    def search_for_keyword(keyword)
      visit_homepage_direct
      fill_in('keyword', :with => keyword)
      click_button 'Find'
    end

    def search_for_keyword_without_visit(keyword)
      fill_in('keyword', :with => keyword)
      click_button 'Find'
    end

    def search_for_keyword_and_location(keyword, address)
      visit_homepage_direct
      fill_in('keyword', :with => keyword)
      fill_in('location', :with => address)
      click_button 'Find'
    end

    def search_for_keyword_and_distance(keyword, distance)
      fill_in('keyword', :with => keyword)
      select(distance, :from => 'radius')
      click_button 'Find'
    end

    def search_all(keyword, location, distance)
      fill_in('keyword', :with => keyword)
      fill_in('location', :with => location)
      select(distance, :from => 'radius')
      click_button 'Find'
    end

    def search_for_nothing
      visit_homepage_direct
      click_button 'Find'
    end

    def visit_details
      page.find(:css, '#list-view li:first-child a').click
    end

=begin
    def visit_nearby_details
      click_link("Burlingame Main")
    end
=end

    def search_and_visit_details
      search_for_keyword_and_location('library', '94010')
      visit_details
    end


    # webbrowser navigation using requirejs
    def back_button_pressed
      page.execute_script("require(['domReady!'], function() { window.history.back(); });")
    end

    def forward_button_pressed
      page.execute_script("require(['domReady!'], function() { window.history.forward(); });")
    end


    # check for distinctive features of pages
    def looks_like_homepage
      expect(page).to have_title "OhanaSMC"
      expect(page).to have_css("#search-container")
      expect(page).to_not have_css("#results-container")
    end

    def looks_like_results_list
      expect(page).to have_css("#search-container")
      expect(page).to have_css("#list-view")
      expect(page).to_not have_css("#map-view")
    end

    def looks_like_results_map
      expect(page).to have_css("#search-container")
      expect(page).to_not have_css("#list-view")
      expect(page).to have_css("#map-view")
    end

    def looks_like_details
      expect(page).to have_css("#search-container")
      expect(page).to have_css("#detail-info")
    end

    def looks_like_about
      expect(page).to have_title "About | OhanaSMC"
      expect(page).to have_css("#about-box")
      expect(page).to have_css("#contribute-box")
      expect(page).to have_css("#feedback-box")
    end

  end
end