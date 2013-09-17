class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :check_language_settings

	# Retrieves language parameter and performs
	# mapping to Google Translate API language code
	# values. Sets cookie with english to [language] setting
	# Deletes cooke if [language] is english or if language
	# parameter is missing.
	def check_language_settings
		if params[:translate].present?

			lang_param = params[:translate].downcase
			if lang_param == 'tagalog'
				lang_param = 'filipino'
			elsif lang_param == 'chinese'
				lang_param = 'chinese (simplified)'
			end

		  lang = language_mapping(lang_param)
			@lang = lang

		  if lang == 'en'
		  	cookies.delete :googtrans
		  end
		  cookies[:googtrans] = "/en/#{lang}"
		else
		  cookies.delete :googtrans
		end
	end

	private

	def language_mapping(language)
    lang = {'english'=>'en','afrikaans'=>'af','albanian'=>'sq','arabic'=>'ar','armenian'=>'hy','azerbaijani'=>'az','basque'=>'eu','belarusian'=>'be','bengali'=>'bn','bosnian'=>'bs','bulgarian'=>'bg','catalan'=>'ca','cebuano'=>'ceb','chinese (simplified)'=>'zh-CN','chinese (traditional)'=>'zh-TW','croatian'=>'hr','czech'=>'cs','danish'=>'da','dutch'=>'nl','estonian'=>'et','filipino'=>'tl','finnish'=>'fi','french'=>'fr','galician'=>'gl','georgian'=>'ka','german'=>'de','greek'=>'el','gujarati'=>'gu','haitian creole'=>'ht','hebrew'=>'iw','hindi'=>'hi','hmong'=>'hmn','hungarian'=>'hu','icelandic'=>'is','indonesian'=>'id','irish'=>'ga','italian'=>'it','japanese'=>'ja','kannada'=>'kn','khmer'=>'km','korean'=>'ko','lao'=>'lo','latvian'=>'lv','lithuanian'=>'lt','macedonian'=>'mk','malay'=>'ms','maltese'=>'mt','marathi'=>'mr','norwegian'=>'no','persian'=>'fa','polish'=>'pl','portuguese'=>'pt','romanian'=>'ro','russian'=>'ru','serbian'=>'sr','slovak'=>'sk','slovenian'=>'sl','spanish'=>'es','swahili'=>'sw','swedish'=>'sv','tamil'=>'ta','telugu'=>'te','thai'=>'th','turkish'=>'tr','ukrainian'=>'uk','urdu'=>'ur','vietnamese'=>'vi','yiddish'=>'yi'}
    return lang[language];
  end

end
