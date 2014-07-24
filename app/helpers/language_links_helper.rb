module LanguageLinksHelper
  def language_link_tag(language_plus_code)
    language = language_plus_code.split(':').first
    code = language_plus_code.split(':').second

    link_to_unless(@current_lang == code, language, "?translate=#{code}", lang: code, class: 'notranslate button-small') do |language|
      content_tag(:span, language, class: 'translate-active button-small')
    end
  end
end
