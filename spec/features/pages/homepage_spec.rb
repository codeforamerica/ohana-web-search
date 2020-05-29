require 'rails_helper'

describe 'Home page header elements' do
  before(:each) do
    visit '/'
  end

  it 'includes correct title' do
    expect(page).to have_title 'SMC-Connect'
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

  it 'includes a link to SMCHSA' do
    within('#app-footer') do
      expect(find_link('San Mateo County Human Services Agency', match: :first)[:href]).
        to eq('http://hsa.smcgov.org/')
    end
  end

  it 'includes the SMCHSA logo' do
    within('#app-footer') do
      all_images = page.all(:xpath, '//img[@src]')
      expect(all_images[1][:src]).to match(/smc_hsa_logotype/)
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
