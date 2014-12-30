require 'rails_helper'

feature 'superscript formatting' do
  scenario 'when the string is safe' do
    VCR.use_cassette(
      'dynamic/location_details/superscript_dynamic',
      erb: { name: 'The 1st, 2nd, 3rd, and 4th of 25th st & broad rd' }
    ) do
      visit_test_location
      expect(page).
        to have_content('The 1st, 2nd, 3rd, and 4th of 25th st & broad rd')
    end
  end

  scenario 'when the string is unsafe', js: true do
    script = '<script>var x=12;var y=34;document.body.innerHTML=x+y;</script>'
    VCR.use_cassette('dynamic/location_details/superscript_dynamic',
                     erb: { name: script }) do
      visit_test_location
      expect(page).
        to_not have_content('579')
      expect(page).
        to have_content(script)
    end
  end
end
