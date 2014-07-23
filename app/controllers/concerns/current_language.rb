module CurrentLanguage
  def current_language
    return 'en' if cookies[:googtrans].nil?
    cookies[:googtrans].split('/')[-1]
  end
end
