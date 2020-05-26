class LocationsController < ApplicationController
  include Cacheable

  def index
    locations = Location.search(params)

    @search = Search.new(locations, Ohanakapa.last_response, params)

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
