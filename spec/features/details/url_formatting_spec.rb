require 'spec_helper'

feature 'url formatting' do

  scenario 'when contains https://' do
    VCR.use_cassette('dynamic/location_details/url_dynamic',
      :erb => { :url => "https://www.smctest.org" }) do
      visit('/organizations/521d33a01974fcdb2b0026a9')
      within('#contact-info') do
        find_link('www.smctest.org')[:href].should == 'https://www.smctest.org'
      end
    end
  end

  scenario 'when contains http://' do
    VCR.use_cassette('dynamic/location_details/url_dynamic',
      :erb => { :url => "http://www.smctest.org" }) do
      visit('/organizations/521d33a01974fcdb2b0026a9')
      within('#contact-info') do
        find_link('www.smctest.org')[:href].should == 'http://www.smctest.org'
      end
    end
  end

  scenario 'when does not contain http:// or https://' do
    VCR.use_cassette('dynamic/location_details/url_dynamic',
      :erb => { :url => "smctest.org" }) do
      visit('/organizations/521d33a01974fcdb2b0026a9')
      within('#contact-info') do
        find_link('smctest.org')[:href].should == 'smctest.org'
      end
    end
  end

  scenario 'when malformed' do
    VCR.use_cassette('dynamic/location_details/url_dynamic',
      :erb => { :url => "http:/www.smctest.org" }) do
      visit('/organizations/521d33a01974fcdb2b0026a9')
      within('#contact-info') do
        find_link('http:/www.smctest.org')[:href].should == 'http:/www.smctest.org'
      end
    end
  end

end