require 'spec_helper'

feature "visits results page" do

  describe "with JavaScript enabled", :js=>true do

    context "via homepage" do
      background do
        search( :path=>'/', :keyword=>'maceo' )
      end

      scenario 'performs valid search' do
        search
        looks_like_results
      end

      scenario 'performs invalid search' do
        search(:keyword=>'asdfg')
        looks_like_no_results
      end

    end

    context "direct" do
      background do
        search( :path=>'/organizations', :keyword=>'maceo' )
      end

      scenario 'performs search' do
        search
        looks_like_results
      end
    end

  end

=begin
  describe "with JavaScript disabled" do

  end
=end

end