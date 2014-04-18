require 'spec_helper'

feature 'page translation', :js do

  background do
    #page.driver.remove_cookie("googtrans") # poltergeist
    page.driver.browser.clear_cookies # webkit
  end

  context 'translation cookie is set to Spanish' do
    it "displays Spanish-language contents" do
      #page.driver.set_cookie("googtrans","/en/es") # poltergeist
      page.driver.browser.
        set_cookie("googtrans=/en/es; path=/; domain=127.0.0.1") # webkit
      visit('/')
      within("#language-box") do
        all_links = all('a')
        expect(all_links).not_to include "Español"
      end
      expect(page).to have_content("Necesito")
    end
  end

  context 'homepage is translated' do
    xit "displays a Spanish-language contents" do
      visit('/')
      find_link("Español").click
      within("#language-box") do
        all_links = all('a')
        expect(all_links).not_to include "Español"
      end
      expect(page).to have_content("Necesito")
    end
  end

  context 'results page is translated' do
    xit "displays a Spanish-language contents" do
      visit('/')
      find_link("Español").click
      find(:css, '#find-btn').click
      delay # give Google Translate a chance to translate page
      expect(page).to have_content("Mostrando")
    end
  end

  context 'page is translated between languages' do
    xit "displays a Spanish-language, Tagalog-language, and English-language contents" do
      visit('/')
      find_link("Español").click
      expect(page).to have_content("Necesito")
      find_link("Tagalog").click
      expect(page).to have_content("Kailangan ko")
      find_link("English").click
      expect(page).to have_content("I Need")
    end
  end

end