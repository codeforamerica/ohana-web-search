class Location
  # Calls the search endpoint of the Ohana API.
  #
  # @param params [Hash] Search options.
  # @return [Array] Array of locations.
  def self.search(params = {})
    Ohanakapa.search('search', params)
  end

  # Calls the locations/{id} endpoint of the Ohana API.
  # Fetches a single location by id.
  #
  # @param id [String] Location id.
  # @return [Sawyer::Resource] Hash of location details.
  def self.get(id)
    Ohanakapa.location(id)
  end
end
