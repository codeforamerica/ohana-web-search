class Organization

  #combines address fields together into one string
  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def market_match?
    self.market_match
  end

  # Gets a single organization details
  # @param id [String] Organization ID.
  # @return [Hashie::Mash] Hash representing a organization's details.
  def self.get(id)
    @client = Ohanakapa.new
    response = @client.organization(id)
  end

  # Performs a query of the API
  # @param params [Object] parameter object.
  # @return [Hashie::Mash] Hash representing a organization's details.
  def self.query(params = {})
    @client = Ohanakapa.new

    # return all results if keyword and location are blank
    if params[:keyword].blank? && params[:location].blank?
      return @client.organizations(params)
    end

    begin
      response = @client.query(params)
    rescue
      response = @client.empty_set
    end
  end

end
