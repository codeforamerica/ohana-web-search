module LanguageLinksHelper
  def language_link_tag(language_plus_code)
    language = language_plus_code.split(':').first
    code = language_plus_code.split(':').second.strip!

    link_to_unless(
      @current_lang == code,
      language, "?translate=#{code}", lang: code, class: no_translate_class
    ) do |language_text|
      content_tag(:a, language_text, lang: code, class: translate_active_class)
    end
  end

  def no_translate_class
    'notranslate button-small link-translate hide'
  end

  def translate_active_class
    'translate-active button-small link-translate hide'
  end
end
