class LanguageLinkTag
  def initialize(language_plus_code, current_lang, view)
    @language_plus_code = language_plus_code
    @current_lang = current_lang
    @view = view
  end

  def call
    view.link_to_unless(
      current_lang == code,
      language, "?translate=#{code}", lang: code, class: no_translate_class
    ) do |language_text|
      view.content_tag(:a, language_text, lang: code, class: translate_active_class)
    end
  end

  private

  attr_reader :language_plus_code, :current_lang, :view

  def language
    language_plus_code.split(':').first
  end

  def code
    language_plus_code.split(':').second.strip!
  end

  def no_translate_class
    'notranslate button-small link-translate hide'
  end

  def translate_active_class
    'translate-active button-small link-translate hide'
  end
end
