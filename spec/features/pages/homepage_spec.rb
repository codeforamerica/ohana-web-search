require 'rails_helper'

describe 'Home page header elements' do
  before(:each) do
    visit '/'
  end

  it 'includes correct title' do
    expect(page).to have_title 'Ohana Web Search'
  end

  it 'includes utility links' do
    expect(page).to have_content 'About'
    expect(page).to have_content 'Feedback'
  end
end

describe 'Home page content elements' do
  before(:each) do
    visit '/'
  end

  it 'includes english language status' do
    expect(find('#language-box')).to have_content('English')
  end

  it 'displays headers for the general links' do
    within('#general-services') do
      expect(page).to have_content 'Government Assistance'
    end
  end

  it 'displays links under the general header' do
    within('#general-services') do
      expect(page).to have_link 'Health Insurance'
    end
  end

  it 'displays headers for the emergency links' do
    within('#emergency-services') do
      expect(page).to have_content 'Reporting'
    end
  end

  it 'displays links under the emergency header' do
    within('#emergency-services') do
      expect(page).to have_link 'Domestic Violence'
    end
  end
end

describe 'Home page footer elements' do
  before(:each) do
    visit '/'
  end

  it 'includes a link to ohanapi.org' do
    within('#app-footer') do
      expect(find_link('view project details')[:href]).
        to eq('http://ohanapi.org')
    end
  end

  it 'includes a link to codeforamerica.org' do
    within('#app-footer') do
      expect(find_link('Code for America')[:href]).
        to eq('http://codeforamerica.org')
    end
  end

  it 'includes a link to the ohana-web-search GitHub repo' do
    within('#app-footer') do
      expect(find_link('Get this app')[:href]).
        to eq('https://github.com/codeforamerica/ohana-web-search')
    end
  end
end
