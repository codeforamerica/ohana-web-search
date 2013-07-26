require 'spec_helper'

feature 'Visitor performs search on home page' do

  scenario 'with valid ZIP code' do
    search(:path=>'/',:location=>'94404')
    expect(page)
      .to have_content("Showing 30 of 49 results within 2 miles of '94404'")
    find_field("location").value.should == "94404"
  end

  scenario 'with numerical-only address greater than 5 digits' do
    invalid_search(:path=>'/',:location=>'123456')
  end

  scenario 'with numerical-only address less than 5 digits' do
    invalid_search(:path=>'/',:location=>'1236')
  end

  scenario 'with numerical-only address that starts with 4 zeros or more' do
    invalid_search(:path=>'/',:location=>'00000')
  end

  scenario 'with only 1 word that contains numbers and letters' do
    invalid_search(:path=>'/',:location=>'0000f')
  end

  scenario 'with a 5-digit zip code that does not exist' do
    invalid_search(:path=>'/',:location=>'11111')
  end

  scenario 'with a zip code containing dash' do
    invalid_search(:path=>'/',:location=>'11111-1')
  end

end