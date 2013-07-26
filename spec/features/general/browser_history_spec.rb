require 'spec_helper'

feature 'Visitor uses the back or forward button', 
:js => true do

  scenario 'to homepage' do
    search(:path=>'/',:location=>'94403')
    back_button_pressed
    looks_like_homepage
  end

  scenario 'from homepage' do
    search(:path=>'/',:location=>'94403')
    back_button_pressed
    forward_button_pressed
    looks_like_results_list
  end

  scenario 'to results page' do
    search(:path=>'/',:location=>'94403')
    search(:keyword=>'food')
    looks_like_results_list
  end

  scenario 'from results page' do
    search(:path=>'/',:location=>'94403')
    search(:keyword=>'food')
    back_button_pressed
    back_button_pressed
    looks_like_homepage
  end

  scenario 'to details page' do
    search(:path=>'/',:location=>'94403')
    visit_details
    back_button_pressed
    forward_button_pressed
    looks_like_details("Hillsdale Community Library")
  end

  scenario 'from details page' do
    search(:path=>'/',:location=>'94403')
    visit_details
    back_button_pressed
    looks_like_results_list
  end

end