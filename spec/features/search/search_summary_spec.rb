require "spec_helper"

# checks for correct page titles of site pages
feature 'Search summary' do

  scenario 'when visiting search results page that has results', :vcr do
    search_for_maceo
    # expect only static and floating search results summary,
    # and that they're only in the results-header
    expect(all(".search-summary", :text=>"Displaying 1 result").count).to eq(2)
    expect(all(".results-header .search-summary", :text=>"Displaying 1 result").count).to eq(2)
  end

  scenario 'when visiting search results page that does not have results', :vcr do
    search_for_no_results
    # expect only static and floating search results summary,
    # and that they're only in the results-header
    expect(all(".search-summary", :text=>"No results").count).to eq(2)
    expect(all(".results-header .search-summary", :text=>"No results").count).to eq(2)
  end

end
