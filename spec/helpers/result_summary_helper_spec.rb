require 'spec_helper'
describe ResultSummaryHelper do

  context 'when no keyword or location' do
    it 'shows result count only' do
      helper.format_summary({ :count => 1, :total_count => 1 })
        .should eq("1 of 1 result")

      helper.format_summary({ :count => 2, :total_count => 2 })
        .should eq("2 of 2 results")
    end
  end

  context 'when keyword but no location' do
    it 'shows result count and keyword' do
      helper.format_summary(
        { :count => 1, :total_count => 1, :keyword => 'market' })
        .should eq("1 of 1 result matching 'market'")

      helper.format_summary(
        { :count => 2, :total_count => 10, :keyword => 'market' })
        .should eq("2 of 10 results matching 'market'")
    end
  end

  context 'when location but no keyword' do
    it 'shows result count within 2 miles of location' do
      helper.format_summary(
        { :count => 1, :total_count => 1, :location => 'san mateo' })
        .should eq("1 of 1 result within 2 miles of 'san mateo'")

      helper.format_summary(
        { :count => 2, :total_count => 10, :location => 'san mateo' })
        .should eq("2 of 10 results within 2 miles of 'san mateo'")
    end
  end

  context 'when both keyword and location' do
    it 'shows result count, keyword with 2 miles of location' do
      helper.format_summary(
        { :count => 1, :total_count => 1, :keyword => 'market',
          :location => 'san mateo'})
        .should eq("1 of 1 result matching 'market' within 2 miles of 'san mateo'")

      helper.format_summary(
        { :count => 2, :total_count => 10, :keyword => 'market',
          :location => 'san mateo'})
        .should eq("2 of 10 results matching 'market' within 2 miles of 'san mateo'")
    end
  end

  context 'when keyword, location and radius' do
    it 'shows result count and keyword within #{radius} miles of location' do
      helper.format_summary(
        { :count => 1,:total_count => 1,:keyword => 'market',
          :location => 'san mateo',:radius => 10 })
        .should eq("1 of 1 result matching 'market' within 10 miles of 'san mateo'")

      helper.format_summary(
        { :count => 2,:total_count => 10,:keyword => 'market',
          :location => 'san mateo',:radius => 10 })
        .should eq("2 of 10 results matching 'market' within 10 miles of 'san mateo'")
    end
  end
end