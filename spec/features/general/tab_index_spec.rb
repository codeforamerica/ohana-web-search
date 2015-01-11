require 'rails_helper'

feature 'tabindex for homepage elements' do
  before { visit '/' }

  it 'gives the keyword field a tabindex of 1' do
    expect(find('#keyword')[:tabindex]).to eq '1'
  end

  it 'gives the search button a tabindex of 2' do
    expect(find('#button-search')[:tabindex]).to eq '2'
  end

  it 'only has one tabindex of 1 and 2' do
    expect(all('*[tabindex]').map { |t| t[:tabindex] }).to eq %w(1 2)
  end
end

feature 'tabindex for search results', :vcr do
  before { visit '/locations' }

  it 'gives the keyword field a tabindex of 1' do
    expect(find('#keyword')[:tabindex]).to eq '1'
  end

  it 'gives the location field a tabindex of 2' do
    expect(find('#location')[:tabindex]).to eq '2'
  end

  it 'gives the agency field a tabindex of 3' do
    expect(find('#org_name')[:tabindex]).to eq '3'
  end

  it 'only has one tabindex of 1, 2, and 3' do
    expect(all('*[tabindex]').map { |t| t[:tabindex] }).to eq %w(1 2 3)
  end
end
