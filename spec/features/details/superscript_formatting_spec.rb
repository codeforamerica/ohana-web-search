require 'spec_helper'

feature 'superscript formatting' do

  scenario 'when the string is safe' do
    VCR.use_cassette('dynamic/location_details/superscript_dynamic',
      :erb => {
        :name => "The 1st, 2nd, 3rd, and 4th of 25th st & broad rd" }) do
      visit('/organizations/521d33a01974fcdb2b0026a9')
      expect(page).
        to have_content("The 1st, 2nd, 3rd, and 4th of 25th st & broad rd")
    end
  end

  scenario 'when the string is unsafe', :js => true do
    VCR.use_cassette('dynamic/location_details/superscript_dynamic',
      :erb => { :name => "<script>var x = 123;var y = 456;document.body.innerHTML = x+y;</script>" }) do
      visit('/organizations/521d33a01974fcdb2b0026a9')
      expect(page).
        to_not have_content("579")
      expect(page).
        to have_content("<script>var x = 123;var y = 456;document.body.innerHTML = x+y;</script>")
    end
  end

end