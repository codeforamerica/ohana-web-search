class LocationsController < ApplicationController
  include Cacheable
  include CurrentLanguage
  before_action :set_current_lang

  def index
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
    id = params[:id].split('/').last
    @location = Location.get(id)

    # @keywords = @location.services.map { |s| s[:keywords] }.flatten.compact.uniq
    @categories = @location.services.map { |s| s[:categories] }.flatten.compact.uniq

    cache_page(@location.updated_at) if @location.present?
  end
end
