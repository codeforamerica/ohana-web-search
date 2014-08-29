require 'rails_helper'

feature 'page translation', :js do
  background do
    # use this with poltergeist
    # page.driver.remove_cookie('googtrans')

    # use this with webkit
    page.driver.browser.clear_cookies
  end

  context 'translation cookie is set to Spanish' do
    it 'displays Spanish-language contents' do
      # use this with poltergeist
      # page.driver.set_cookie('googtrans','/en/es')

      # use this with webkit
      page.driver.browser.
        set_cookie('googtrans=/en/es; path=/; domain=lvh.me')
      page.driver.browser.
        set_cookie('googtrans=/en/es; path=/; domain=.lvh.me')

      visit("http://www.lvh.me:#{Capybara.server_port}/")
      within('#search-top-utilities .language-box') do
        all_links = all('a')
        expect(all_links).not_to include 'Español'
      end
      expect(page).to have_content('Necesito')
    end
  end

  context 'homepage is translated' do
    it 'displays translated contents' do
      visit("http://www.lvh.me:#{Capybara.server_port}/")
      within('#search-top-utilities .language-box') do
        find_link('Español').click
        delay
        expect(page.driver.cookies['googtrans']).to eq('/en/es')
        all_links = all('a')
        expect(all_links).not_to include 'Español'
      end
      expect(page).to have_content('Necesito')
    end
  end

  context 'results page is translated', :vcr do
    it 'displays translated contents' do
      visit("http://www.lvh.me:#{Capybara.server_port}/")
      find('#search-top-utilities .language-box').find_link('Español').click
      delay
      find(:css, '#button-search').click
      delay # give Google Translate a chance to translate page
      expect(page).to have_content('Encontrar') # 'Encontrar' = 'Find'
    end
  end

  context 'page is translated between languages' do
    it 'displays translated content for each language' do
      visit("http://www.lvh.me:#{Capybara.server_port}/")
      find('#search-top-utilities .language-box').find_link('Español').click
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/es')
      expect(page).to have_content('Necesito')
      find('#search-top-utilities .language-box').find_link('Tagalog').click
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/tl')
      expect(page).to have_content('Kailangan ko')
      find('#search-top-utilities .language-box').find_link('English').click
      expect(page).to have_content('I need')
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/en')
    end
  end
end
