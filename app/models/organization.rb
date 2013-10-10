class Organization

  # Calls the search endpoint of the Ohana API
  #
  # If params doesn't include at least one of keyword, location,
  # or language, the wrapper will return a BadRequest error,
  # which we can rescue and inspect. If the error message includes
  # "missing", that means one of the required params is missing,
  # and we can choose to display all locations in that case.
  # Otherwise, it's either because the location or radius is invalid,
  # in which case we return an empty result.
  #
  # @param params [Hash] Search options.
  # @return [Array] Array of locations.
  def self.search(params = {})
    begin
      Ohanakapa.search("search", params)
    rescue Ohanakapa::BadRequest => e
      if e.to_s.include?("missing")
        Ohanakapa.locations(params)
      else
        Ohanakapa.search("search", keyword: "asdfasg")
      end
    end
  end

  # Calls the locations/{id} endpoint of the Ohana API
  # Fetches a single location by id
  #
  # If the id doesn't correspond to an existing location the wrapper
  # will return a NotFound error, which we need to rescue and deal with
  # appropriately by redirecting to a custom 404 page or to the home page
  # with an alert.
  #
  # @param id [String] Location id.
  # @return [Sawyer::Resource] Hash of location details.
  def self.get(id)
    begin
      Ohanakapa.location(id)
    rescue Ohanakapa::NotFound
      return false
    end
  end

end
