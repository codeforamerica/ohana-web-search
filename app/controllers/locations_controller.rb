class LocationsController < ApplicationController
  include CurrentLanguage
  include Cacheable

  def index
    # To enable Google Translation of keywords,
    # uncomment lines 9-11 and 19, and see documentation for
    # GOOGLE_TRANSLATE_API_KEY in config/application.example.yml.
    translator = KeywordTranslator.new(
      params[:keyword], current_language, 'en', 'text')
    params[:keyword] = translator.translated_keyword

    locations = Location.search(params)

    @search = Search.new(locations, Ohanakapa.last_response, params)

    # Populate the keyword search field with the original term
    # as typed by the user, not the translated word.
    params[:keyword] = translator.original_keyword

    cache_page(locations.max_by(&:updated_at).updated_at) if locations.present?
  end

  def show
    @location = Location.get(location_id)

    if @location[:services].present?
      @categories = @location.services.map { |s| s[:categories] }.
                    flatten.compact.uniq
    end

    cache_page(@location.updated_at) if @location.present?
  end

  private

  def location_id
    params[:id].split('/').last
  end
end
