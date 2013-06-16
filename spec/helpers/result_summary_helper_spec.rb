require 'spec_helper'
describe ResultSummaryHelper do

	context 'formats result summary' do
		
		it 'has no keyword or location' do
			ResultSummaryHelper.format_summary({:count=>1,:total_count=>1}).should eq("Showing 1 of 1 result")
			ResultSummaryHelper.format_summary({:count=>2,:total_count=>2}).should eq("Showing 2 of 2 results")
		end

		it 'has a keyword but not a location' do
			ResultSummaryHelper.format_summary({:count=>1,:total_count=>1,:keyword=>'market'}).should eq("Showing 1 of 1 result matching 'market'")
			ResultSummaryHelper.format_summary({:count=>2,:total_count=>10,:keyword=>'market'}).should eq("Showing 2 of 10 results matching 'market'")
		end

		it 'has a location but not a keyword' do
			ResultSummaryHelper.format_summary({:count=>1,:total_count=>1,:location=>'san mateo'}).should eq("Showing 1 of 1 result within 2 miles of 'san mateo'")
			ResultSummaryHelper.format_summary({:count=>2,:total_count=>10,:location=>'san mateo'}).should eq("Showing 2 of 10 results within 2 miles of 'san mateo'")
		end

		it 'has a keyword and a location' do
			ResultSummaryHelper.format_summary({:count=>1,:total_count=>1,:keyword=>'market',:location=>'san mateo'}).should eq("Showing 1 of 1 result matching 'market' within 2 miles of 'san mateo'")
			ResultSummaryHelper.format_summary({:count=>2,:total_count=>10,:keyword=>'market',:location=>'san mateo'}).should eq("Showing 2 of 10 results matching 'market' within 2 miles of 'san mateo'")
		end

		it 'has a keyword and a location and a radius' do
			ResultSummaryHelper.format_summary({:count=>1,:total_count=>1,:keyword=>'market',:location=>'san mateo',:radius=>10}).should eq("Showing 1 of 1 result matching 'market' within 10 miles of 'san mateo'")
			ResultSummaryHelper.format_summary({:count=>2,:total_count=>10,:keyword=>'market',:location=>'san mateo',:radius=>10}).should eq("Showing 2 of 10 results matching 'market' within 10 miles of 'san mateo'")
		end

	end

end