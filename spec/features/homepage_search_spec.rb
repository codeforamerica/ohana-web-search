feature 'Visitor performs search on home page' do

 
  scenario 'with valid ZIP code' do
    search_for_address "94403"

    expect(page).to have_content("Showing 30 of 62 results within 1 mile of '94403'")
    find_field("location").value.should == "94403"
  end

# TODO - implement the following tests when the Ohana API returns a bad request for these searches

  xscenario 'with numerical-only address greater than 5 digits' do
    search_for_address '123456'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  xscenario 'with numerical-only address less than 5 digits' do
    search_for_address '1236'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  xscenario 'with numerical-only address that starts with 4 zeros or more' do
    search_for_address '00000'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  xscenario 'with only 1 word that contains numbers and letters' do
    search_for_address '0000f'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  xscenario 'with a 5-digit zip code that does not exist' do
    search_for_address '11111'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  xscenario 'with a zip code containing dash' do
    search_for_address '11111-1'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

=begin
# tests need refactoring to handle ajax and calls to Ohana API

  scenario 'for address only, with default distance, and 1 result expected' do
    organization = FactoryGirl.create(:organization)
    search_for_address '1800 Easton Drive, Burlingame, CA'
    expect(page).to have_content("1 result within 2 miles of '1800 Easton Drive, Burlingame, CA'")
  end

  scenario 'by clicking Find button directly, with no address or keyword specified' do
    organization = FactoryGirl.create(:organization)
    search_for_nothing
    expect(page).to have_content('Browse all 1 entries')
  end

  scenario 'for keyword only, with default distance, and 1 result expected' do
    organization = FactoryGirl.create(:organization)
    search_for_keyword 'library'
    expect(page).to have_content("1 result matching 'library'")
  end

  scenario 'for both keyword and location, with default distance, and 1 result expected' do
    organization = FactoryGirl.create(:organization)
    search_for_keyword_and_location('library', '94010')
    expect(page).to have_content("1 result matching 'library' within 2 miles of '94010'")
    find_field("location").value.should == "94010"
    find_field("search_term").value.should == "library"
  end

  scenario 'for a keyword that should return no results' do
    organization = FactoryGirl.create(:organization)
    search_for_keyword_and_location('asdad', '94010')
    expect(page).to have_content("0 results matching 'asdad' within 2 miles of '94010'")
    expect(page).to have_content("NO RESULTS")
  end

  scenario 'for a keyword that should return a result with no address' do
    organization = FactoryGirl.create(:org_without_address)
    search_for_keyword 'parks'
    expect(page).to have_content("1 result matching 'parks'")
    expect(page).to have_content("Huddart Park")
  end
=end

end