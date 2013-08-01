require 'spec_helper'

feature "visits details page" do

  describe "with JavaScript enabled", :js=>true do
		
    context "via homepage" do

      background do
        search( :path=>'/', :keyword=>'maceo' )
        visit_details
        looks_like_details( 'Gimme 1 2 3' )
      end

    	# tests detail/character-limiter
      scenario 'has functional content limiter for description content' do
      	find(:css, "#detail-info .description a").should have_content("more")
      	find(:css, "#detail-info .description a").click
      	find(:css, "#detail-info .description a").should have_content("less")
      end

    	# tests detail/term-popup-manager
      scenario 'has functional popup for terms' do
      	within ("#detail-info .payments-accepted") do
  	    	expect(page).to_not have_content("Women, Infants, and Children")
  	    	find(:css, ".popup-term", :text=>"WIC").click
  	    	expect(page).to have_content("Women, Infants, and Children")
    		end
      end

      # tests detail/term-popup-manager
      scenario 'has detail map' do
        within ("#detail-info .map") do
          expect(page).to have_content("Google")
        end
      end

      scenario 'performs search' do
  	    search
  	    looks_like_results
  	  end

      scenario 'returns to original results' do
        find("#results-container").find("nav").find("a").click
        expect(page).to have_content("Showing 1 of 1 result matching 'maceo'")
      end
    end

    context "direct" do
      background do
        visit('/organizations/51de0b9fa4a4d8b01b3e459d')
      end

      scenario 'performs search' do
        search
        looks_like_results
      end

    end

  end

=begin
  describe "with JavaScript disabled" do

  end
=end

end