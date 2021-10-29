class LocationsController < ApplicationController
  include Cacheable

  def index
    locations = Location.search(params)

    @search = Search.new(locations, Ohanakapa.last_response, params)

    cache_page(locations.max_by(&:updated_at).updated_at) if locations.present?
  end

  def show
    @location = Location.get(location_id)

    if @location[:services].present?
      @categories = @location.services.pluck(:categories).
                    flatten.compact.uniq
    end

    cache_page(@location.updated_at) if @location.present?
  end

  private

  def location_id
    params[:id].split('/').last
  end
end
