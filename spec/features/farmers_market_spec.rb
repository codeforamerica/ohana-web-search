feature 'Visitor views the details page of a farmers market' do

  scenario 'market accepts SNAP and sells cheese' do
    organization = FactoryGirl.create(:farmers_market)
    search_for_keyword_and_location('pescadero', 'la honda, ca')
    click_link("Pescadero Grown")
    expect(page).to have_content("8875 La Honda Road La Honda, CA 94020")
    expect(page).to have_content("Payment methods accepted: Credit WIC SFMNP SNAP")
    expect(page).to have_content("Products sold: Cheese")
    expect(page).to have_content("May - November Tuesday 3:00 PM to 7:00 PM")
    page.should have_link("http://Www.pescaderogrown.org", :href => "http://Www.pescaderogrown.org") 
  end

  @javascript
  xscenario 'reading the page' do
    page.evaluate_script("$('#info-screen .content').css('font-size')").should == '14px'
  end

end