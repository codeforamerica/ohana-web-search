class HomeController < ApplicationController
  include CurrentLanguage
  before_action :set_current_lang
end
