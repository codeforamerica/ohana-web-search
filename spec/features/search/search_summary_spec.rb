require 'rails_helper'

feature 'Search summary' do
  scenario 'when visiting search results page that has results', :vcr do
    search_for_example
    # Expect only floating search results summary,
    # and expect that it's only in the results-header.
    expect(all('.search-summary', text: 'Displaying 1 result').count).to eq(1)
    expect(all('.results-header .search-summary', text: 'Displaying 1 result').
      count).to eq(1)
  end

  scenario 'when visiting search results page that does not have results',
           :vcr do
    search_for_no_results
    # Expect only floating search results summary,
    # and expect that it's only in the results-header.
    expect(all('.search-summary', text: 'No results').count).to eq(1)
    expect(all('.results-header .search-summary', text: 'No results').count).
      to eq(1)
  end
end
