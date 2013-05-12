module Features
  module SessionHelpers
    def search_for_both(address, distance)
      visit ('/')
      fill_in('location', :with => address)
      select(distance, :from => 'miles')
      click_button 'Find'
    end

    def search_for_address(address)
      visit ('/')
      fill_in('location', :with => address)
      click_button 'Find'
    end

    def search_for_keyword(keyword)
      visit ('/')
      fill_in('search-term', :with => keyword)
      click_button 'Find'
    end

    def search_for_keyword_without_visit(keyword)
      fill_in('search-term', :with => keyword)
      click_button 'Find'
    end

    def search_for_keyword_and_location(keyword, address)
      visit ('/')
      fill_in('search-term', :with => keyword)
      fill_in('location', :with => address)
      click_button 'Find'
    end

    def search_for_nothing
      visit ('/')
      click_button 'Find'
    end

    def visit_details
      click_link("Burlingame, Easton Branch")
    end

    def visit_nearby_details
      click_link("Burlingame Main")
    end

    def search_and_visit_details
      search_for_keyword_and_location('library', '94010')
      visit_details
    end
  end
end