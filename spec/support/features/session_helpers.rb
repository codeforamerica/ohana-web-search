module Features
  module SessionHelpers

    # search helpers
    def search(options = {})
      keyword = options[:keyword]
      fill_in('keyword', :with => keyword)

      if options[:location].present?
        set_location_filter(options)
      end

      find('#find-btn').click
    end

    def search_from_home(options = {})
      visit ("/")
      keyword = options[:keyword]
      fill_in('keyword', :with => keyword)
      find('#find-btn').click
    end

    def search_for_maceo
      visit('/organizations?utf8=✓&keyword=maceo')
    end


    # helpers for filters
    def set_location_filter(options = {})
      set_filter("location",options[:location])
    end

    def set_service_area_filter(options = {})
      set_filter("service-area",options[:service_area])
    end

    def set_kind_filter(options = {})
      set_filter("kind",options[:kind])
    end

    # @param options [Object] the URL parameters object
    # @param name [String] the CSS name of the field
    # @oaram field [Symbol] the field to look up in the options object.
    def set_filter(name,field,custom=true)
      within(".require-loaded") do
        within("##{name}-options") do
          find(".closed").click
          if field.present? && custom == true
            find(".add .toggle").trigger('mousedown')
            fill_in("#{name}-option-input", :with => field)
          elsif custom == false
            find(".toggle-group",:text=>field).trigger('mousedown')
          else
            first("label").click
          end
        end
      end
    end

    # Tests opening and closing the fieldset by clicking the legend.
    # @param name [String] The name of the filter field to test.
    # @param val [String] The value that should be showing in the current toggle.
    # @param count [Number] The amount of toggle that should be showing.
    def test_filter_legend(name,val="All",count=2)
      find(".require-loaded")
      within("##{name}-options") do
        # test clicking legend functionality
        expect(all(".current-option label").last).to have_content(val)
        find(".closed").trigger("mousedown")
        page.should have_selector(".open")
        find(".available-options").should have_css(".toggle-group", :count=>count)
        find(".open").trigger("mousedown")
        expect(all(".current-option label").last).to have_content(val)
      end
    end

    # Tests opening and closing the fieldset by clicking the current toggle.
    # @param name [String] The name of the filter field to test.
    # @param val [String] The value that should be showing in the current toggle.
    # @param count [Number] The amount of toggle that should be showing.
    def test_filter_toggle(name,val="All",count=2)
      find(".require-loaded")
      within("##{name}-options") do
        # test clicking toggle functionality
        expect(all(".current-option label").last).to have_content(val)
        all(".current-option label").last.trigger("mousedown")
        page.should have_selector(".open")
        find(".available-options").should have_css(".toggle-group", :count=>count)
        find(".options label",:text=>val).trigger("mousedown")
        expect(all(".current-option label").last).to have_content(val)
      end
    end

    # Opens the filter fieldset, sets a custom value, and closes the fieldset.
    # @param name [String] The name of the filter field to test.
    # @param val [String] The custom value that should be applied to the toggle.
    def fill_filter_custom_field(name,val)
      find(".require-loaded")
      within("##{name}-options") do
        # test adding custom value functionality
        find(".closed").trigger("mousedown")
        page.should have_selector(".open")
        find(".available-options").should have_css(".toggle-group", :count=>2)
        all(".toggle-group-wrapper.add label").first.trigger("mousedown")
        fill_in("#{name}-option-input", :with => val)
        all(".toggle-group-wrapper.add label").first.trigger("mousedown")
      end
    end

    def test_filter_custom_value_no_results(name,field)
      set_filter(name,field)
      find('#find-btn').click

      find(".require-loaded")
      within("##{name}-options") do
        find(".closed").trigger('mousedown')
        page.should have_selector(".open")
        find(".available-options").should have_css(".toggle-group", :count=>2)
        find_field("#{name}-option-input").value.should eq field
      end
    end

    # navigation helpers
    def visit_details
      page.find("#list-view").first('a').trigger('click')
    end

    def looks_like_results
      page.should have_content("SanMaceo Example Agency")
      page.should have_content("1 result")
      page.should have_title "1 result"
    end

    def looks_like_puente
      page.should have_content("Puente Resource Center")
      page.should have_content("1 result")
      page.should have_title "1 result"
    end

    def looks_like_no_results
      page.should have_selector(".no-results")
      page.should have_content("your search returned no results.")
      page.should have_selector("#search-summary")
      page.should_not have_selector('#map-canvas')
    end

    def looks_like_location
      find("#detail-info .description a").should have_content("more")
      find("#detail-info .description a").click
      find("#detail-info .description a").should have_content("less")

      page.should have_title "San Maceo Agency | SMC-Connect"

      page.should have_content("Works to control")
      page.should have_content("Profit and nonprofit")
      page.should have_content("Marin County")
      page.should have_content("Walk in")
      page.should have_content("permits and photocopying")
      page.should have_content("Russian")
      page.should have_content("Special parking")
      page.should have_link("Print")
      page.should have_link("Directions")
    end

    def looks_like_market
      find("#detail-info .description a").should have_content("more")
      find("#detail-info .description a").click
      find("#detail-info .description a").should have_content("less")

      page.should have_title "San Maceo Agency | SMC-Connect"

      within ("#detail-info .payments-accepted") do
        page.should_not have_content("Women, Infants, and Children")
        find(".popup-term", :text=>"WIC").trigger(:mousedown)
        page.should have_content("Women, Infants, and Children")
      end
      page.should have_content("Works to control")
      page.should have_content("Profit and nonprofit")
      page.should have_content("Marin County")
      page.should have_content("Walk in")
      page.should have_content("permits and photocopying")
      page.should have_content("Russian")
      page.should have_content("Special parking")
      page.should have_link("Print")
      page.should have_link("Directions")
    end

    def looks_like_homepage
      page.should have_title "SMC-Connect"
      page.should have_content "About"
      page.should have_content "Contribute"
      page.should have_content "Feedback"
      page.should have_content "I need"
      page.should have_content "reporting"
      page.should have_content "government assistance"
      page.should_not have_title "1 result"
      find("#language-box").should have_content("English")

      within("#app-footer") do
        find_link('San Mateo County Human Services Agency')[:href].should == 'http://www.co.sanmateo.ca.us/portal/site/humanservices'
        find_link('Code for America')[:href].should == 'http://codeforamerica.org'
        find_link('Get this app')[:href].should == 'https://github.com/codeforamerica/ohana-web-search'
        find_link('view project details')[:href].should == 'http://ohanapi.org'
      end

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
      sleep(2)
    end


  end
end