class Search
  attr_reader :locations

  def initialize(locations, response, params)
    @locations = locations
    @response = response
    @params = params
  end

  def map_data
    @locations.map do |location|
      next unless location.coordinates.present?
      {
        latitude: location.latitude,
        longitude: location.longitude,
        name: location.name,
        org_name: location.organization.name,
        slug: location.slug,
        street_address: location.address.street,
        city: location.address.city
      }
    end.compact
  end

  def results
    Paginator.new(@response, @params).results
  end
end
