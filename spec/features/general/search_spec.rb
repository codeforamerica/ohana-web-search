require 'spec_helper'

feature 'Visitor performs search on home page' do

  scenario 'with valid ZIP code' do
    search(:path=>'/',:location=>'94404')
    expect(page)
      .to have_content("Showing 30 of 100 results within 2 miles of '94404'")
    find_field("location").value.should == "94404"
  end

  scenario 'with numerical-only address greater than 5 digits' do
    search(:path=>'/',:location=>'123456')
    looks_like_invalid_search(:location=>'123456')
  end

  xscenario 'with numerical-only address less than 5 digits' do
    search(:path=>'/',:location=>'1236')
    looks_like_invalid_search(:location=>'1236')
  end

  scenario 'with numerical-only address that starts with 4 zeros or more' do
    search(:path=>'/',:location=>'00000')
    looks_like_invalid_search(:location=>'00000')
  end

  scenario 'with only 1 word that contains numbers and letters' do
    search(:path=>'/',:location=>'0000f')
    looks_like_invalid_search(:location=>'0000f')
  end

  scenario 'with a 5-digit zip code that does not exist' do
    search(:path=>'/',:location=>'11111')
    looks_like_invalid_search(:location=>'11111')
  end

  xscenario 'with a zip code containing dash' do
    search(:path=>'/',:location=>'11111-1')
    looks_like_invalid_search(:location=>'11111-1')
  end

end