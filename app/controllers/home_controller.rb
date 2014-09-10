class HomeController < ApplicationController
  include CurrentLanguage

  def index
    @current_lang = current_language
  end
end
