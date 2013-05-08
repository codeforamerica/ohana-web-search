feature 'Visitor performs search' do
  scenario 'with valid ZIP code and within 5 miles' do
    search_for_both '94403', '5 miles'

    expect(page).to have_content('results within 5 miles of 94403')
  end

  scenario 'with numerical-only address greater than 5 digits' do
    search_for_both '123456', '10 miles'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  scenario 'with numerical-only address less than 5 digits' do
    search_for_both '1236', '10 miles'

    expect(page).to have_content('Please enter a full address or a valid 5-digit ZIP code.')
  end

  scenario 'for address only, with default distance, and 1 result expected' do
    organization = FactoryGirl.create(:organization)
    search_for_address '94010'
    expect(page).to have_content('1 result within 2 miles of 94010')
  end

  scenario 'by clicking Find button directly, with no address or keyword specified' do
    search_for_nothing
    expect(page).to have_content('total results')
  end

  def search_for_both(address, distance)
    visit ('/')
    fill_in('address', :with => address)
    select(distance, :from => 'miles')
    click_button 'Find >>>'
  end

  def search_for_address(address)
    visit ('/')
    fill_in('address', :with => address)
    click_button 'Find >>>'
  end

  def search_for_nothing
    visit ('/')
    click_button 'Find >>>'
  end
end