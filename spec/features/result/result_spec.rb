require 'spec_helper'

feature "visits results page" do

  describe "with JavaScript enabled", :js=>true do

    context "via homepage" do
      background do
        search( :path=>'/', :keyword=>'maceo' )
        looks_like_results_list
      end

      scenario 'performs search' do
        search
        looks_like_results_list
      end

    end

    context "direct" do
      background do
        search( :path=>'/organizations', :keyword=>'maceo' )
        looks_like_results_list
      end

      scenario 'performs search' do
        search
        looks_like_results_list
      end
    end

  end

=begin
  describe "with JavaScript disabled" do

  end
=end

end