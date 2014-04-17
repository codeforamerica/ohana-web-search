class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_translation_cookie

  # Retrieves translate parameter as language code.
  # Sets cookie with english -> [translate] language code value.
  # Deletes cookie if [translate] is english
  def set_translation_cookie

    if params[:translate].present?

      # List of used language code values are as follows:
      # {'english'=>'en','afrikaans'=>'af','albanian'=>'sq','arabic'=>'ar',
      # 'armenian'=>'hy','azerbaijani'=>'az','basque'=>'eu','belarusian'=>'be',
      # 'bengali'=>'bn','bosnian'=>'bs','bulgarian'=>'bg','catalan'=>'ca',
      # 'cebuano'=>'ceb','chinese (simplified)'=>'zh-CN','chinese (traditional)'=>'zh-TW',
      # 'croatian'=>'hr','czech'=>'cs','danish'=>'da','dutch'=>'nl','estonian'=>'et',
      # 'filipino'=>'tl','finnish'=>'fi','french'=>'fr','galician'=>'gl','georgian'=>'ka',
      # 'german'=>'de','greek'=>'el','gujarati'=>'gu','haitian creole'=>'ht','hebrew'=>'iw',
      # 'hindi'=>'hi','hmong'=>'hmn','hungarian'=>'hu','icelandic'=>'is','indonesian'=>'id',
      # 'irish'=>'ga','italian'=>'it','japanese'=>'ja','kannada'=>'kn','khmer'=>'km',
      # 'korean'=>'ko','lao'=>'lo','latvian'=>'lv','lithuanian'=>'lt','macedonian'=>'mk',
      # 'malay'=>'ms','maltese'=>'mt','marathi'=>'mr','norwegian'=>'no','persian'=>'fa',
      # 'polish'=>'pl','portuguese'=>'pt','romanian'=>'ro','russian'=>'ru','serbian'=>'sr',
      # 'slovak'=>'sk','slovenian'=>'sl','spanish'=>'es','swahili'=>'sw','swedish'=>'sv',
      # 'tamil'=>'ta','telugu'=>'te','thai'=>'th','turkish'=>'tr','ukrainian'=>'uk',
      # 'urdu'=>'ur','vietnamese'=>'vi','yiddish'=>'yi'}

      @current_lang = params[:translate]

      # clear all translation cookies
      cookies.delete(:googtrans, :domain => "#{ENV['DOMAIN_NAME']}")
      cookies.delete(:googtrans, :domain => ".#{ENV['DOMAIN_NAME']}")
      cookies.delete(:googtrans, :domain => "www.#{ENV['DOMAIN_NAME']}")
      cookies.delete(:googtrans, :domain => ".www.#{ENV['DOMAIN_NAME']}")

      # set translation cookie

      # The "DOMAIN_NAME" environment variable should be set
      # to your app's domain name, without the subdomain.
      # If you're on Heroku, that means setting it to "herokuapp.com".
      # If you have a custom domain name, like "www.smc-connect.org", that
      # means setting it to "smc-connect.org".

      # In development, it should only be set to a 2-level domain name,
      # like "lvh.me", or "myapp.dev" if you're using Pow. You can set it in
      # config/application.yml.

      # Translation won't work with "localhost", so please open the site
      # locally via http://lvh.me:{port number}

      # Read more about lvh.me here:
      # http://matthewhutchinson.net/2011/1/10/configuring-subdomains-in-development-with-lvhme
      # Pow should work too if you prefer that: http://pow.cx/
      cookies[:googtrans] = {
        value: "/en/#{@current_lang}",
        domain: "#{ENV['DOMAIN_NAME']}"
      }

    elsif cookies[:googtrans].present?
      @current_lang = cookies[:googtrans].split('/')[-1]
    else
      @current_lang = 'en'
    end

  end

end
