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

    fresh_when(cache_settings(locations))
  end

  def show
    id = params[:id].split('/').last
    @location = Location.get(id)

    # @keywords = @location.services.map { |s| s[:keywords] }.flatten.compact.uniq
    @categories = @location.services.map { |s| s[:categories] }.flatten.compact.uniq

    fresh_when last_modified: @location.updated_at, public: true
  end

  private

  def cache_settings(locations)
    return default_cache_settings(locations) if locations.blank?
    default_cache_settings(locations).except(:etag)
  end

  def default_cache_settings(locations)
    {
      last_modified: locations.max_by(&:updated_at).try(:updated_at),
      etag: locations,
      public: true
    }
  end
end
