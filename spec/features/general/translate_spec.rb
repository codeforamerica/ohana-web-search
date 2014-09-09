require 'rails_helper'

feature 'page translation', :js do

  # Force Capybara not to use 127.0.0.1 for cookie domain.
  # From http://stackoverflow.com/
  # questions/6536503/capybara-with-subdomains-default-host
  def capybara_host(host)
    default_url_options[:host] = host
    Capybara.app_host = "http://#{host}"
  end

  background do
    # use this with poltergeist
    # page.driver.remove_cookie('googtrans')

    # use this with webkit
    page.driver.browser.clear_cookies
    capybara_host "#{ENV['DOMAIN_NAME']}:4000/"
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

      visit('/')
      within('#language-box') do
        all_links = all('a')
        expect(all_links).not_to include 'Español'
      end
      expect(page).to have_content('Necesito')
    end
  end

  context 'homepage is translated' do
    it 'displays a Spanish-language contents' do
      visit('/')
      find_link('Español').click
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/es')
      within('#language-box') do
        all_links = all('a')
        expect(all_links).not_to include 'Español'
      end
      expect(page).to have_content('Necesito')
    end
  end

  context 'results page is translated' do
    it 'displays a Spanish-language contents' do
      visit('/')
      find_link('Español').click
      find(:css, '#button-search').click
      delay # give Google Translate a chance to translate page
      expect(page).to have_content('Encontrar') # 'Encontrar' = 'Find'
    end
  end

  context 'page is translated between languages' do
    it 'displays a Spanish-, Tagalog-, and English-language contents' do
      visit('/')
      find_link('Español').click
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/es')
      expect(page).to have_content('Necesito')
      find_link('Tagalog').click
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/tl')
      expect(page).to have_content('Kailangan ko')
      find_link('English').click
      expect(page).to have_content('I need')
      delay
      expect(page.driver.cookies['googtrans']).to eq('/en/en')
    end
  end
end
