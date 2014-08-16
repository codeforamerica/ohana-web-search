class HomeController < ApplicationController
  include GoogleTranslator
  include CurrentLanguage

  def index
    @current_lang = current_language
  end
end
