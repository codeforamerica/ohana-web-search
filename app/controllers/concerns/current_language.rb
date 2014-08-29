module CurrentLanguage
  def current_language
    return 'en' if cookies[:googtrans].nil?
    cookies[:googtrans].split('/').last
  end

  def set_current_lang
    @current_lang = current_language
  end
end
