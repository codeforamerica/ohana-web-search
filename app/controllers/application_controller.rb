class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :set_translation_cookie

	# Retrieves translate parameter and performs
	# mapping to Google Translate API language code
	# values. Sets cookie with english -> [translate] language value.
	# Deletes cookie if [translate] is english
	def set_translation_cookie
		if params[:translate].present?

			# List of used values are as follows:
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

		  lang = params[:translate]

		  if lang == 'en'
		  	cookies.delete(:name=>:googtrans,:domain=>:all)
		  else
		  	cookies[:googtrans] = {
					:value => "/en/#{lang}",
					:domain => :all
				}
				#headers['Set-Cookie'] = "googtrans=/en/#{lang};domain=.herokuapp.com"
				#headers['Set-Cookie'] = "googtrans=/en/#{lang};domain=ohana-staging.herokuapp.com"
				#headers['Set-Cookie'] = "googtrans=/en/#{lang};domain=.ohana-staging.herokuapp.com"
		  end

		else
			lang = 'en'
		end

		if cookies[:googtrans].present?
			@current_lang = cookies[:googtrans][4..cookies[:googtrans].length]
		else
			@current_lang = lang
		end
	end

end
