require 'spec_helper'
describe ResultSummaryHelper do

	context 'formats result summary' do
		
		it 'has no keyword or location' do
			ResultSummaryHelper.format({:count=>1}).should eq("1 result")
			ResultSummaryHelper.format({:count=>2}).should eq("2 results")
		end

		it 'has a keyword but not a location' do
			ResultSummaryHelper.format({:count=>1,:keyword=>'market'}).should eq("1 result matching 'market'")
			ResultSummaryHelper.format({:count=>2,:keyword=>'market'}).should eq("2 results matching 'market'")
		end

		it 'has a location but not a keyword' do
			ResultSummaryHelper.format({:count=>1,:location=>'san mateo'}).should eq("1 result within 2 miles of 'san mateo'")
			ResultSummaryHelper.format({:count=>2,:location=>'san mateo'}).should eq("2 results within 2 miles of 'san mateo'")
		end

		it 'has a keyword and a location' do
			ResultSummaryHelper.format({:count=>1,:keyword=>'market',:location=>'san mateo'}).should eq("1 result matching 'market' within 2 miles of 'san mateo'")
			ResultSummaryHelper.format({:count=>2,:keyword=>'market',:location=>'san mateo'}).should eq("2 results matching 'market' within 2 miles of 'san mateo'")
		end

		it 'has a keyword and a location and a radius' do
			ResultSummaryHelper.format({:count=>1,:keyword=>'market',:location=>'san mateo',:radius=>10}).should eq("1 result matching 'market' within 10 miles of 'san mateo'")
			ResultSummaryHelper.format({:count=>2,:keyword=>'market',:location=>'san mateo',:radius=>10}).should eq("2 results matching 'market' within 10 miles of 'san mateo'")
		end

	end

end