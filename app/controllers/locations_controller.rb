class LocationsController < ApplicationController
  include CurrentLanguage

  def index
    translator = KeywordTranslator.new(
      params[:keyword], current_language, 'en', 'text')
    params[:keyword] = translator.translated_keyword

    locations = Location.search(params)

    @search = Search.new(locations, Ohanakapa.last_response, params)

    # Populate the keyword search field with the original term
    # as typed by the user, not the translated word.
    params[:keyword] = translator.original_keyword
  end

  def show
    id = params[:id].split('/')[-1]
    @location = Location.get(id)

    @categories = @location.services.map { |s| s[:categories] }.flatten.compact
  end
end
