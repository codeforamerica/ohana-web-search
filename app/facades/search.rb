class Search
  attr_reader :locations

  def initialize(locations, response, params)
    @locations = locations
    @response = response
    @params = params
  end

  def map_data
    @locations.map do |location|
      next if location.coordinates.blank?
      hash_for(location)
    end.compact
  end

  def hash_for(location)
    {
      kind: location.kind,
      latitude: location.latitude,
      longitude: location.longitude,
      name: location.name,
      org_name: location.organization.name,
      slug: location.slug,
      street_address: location.address.street,
      city: location.address.city
    }
  end

  def results
    Paginator.new(@response, @params).results
  end
end
