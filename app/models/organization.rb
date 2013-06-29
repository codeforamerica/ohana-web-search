class Organization

  #combines address fields together into one string
  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def market_match?
    self.market_match
  end

  def self.find_by_keyword_and_location(keyword, location, radius)
    if keyword.blank? && location.blank?
      result = self.all
      return result, "Browse all #{result.size} entries"
    elsif keyword.blank? && location.present?
      result = self.near(location, radius)
      return result, "#{TextHelper.pluralize(result.size, 'result')} within #{TextHelper.pluralize(radius, 'mile')} of '#{location}'"
    elsif keyword.present? && location.present?
      result = self.find_by_keyword(keyword).find_by_location(location, radius)
      return result, "#{TextHelper.pluralize(result.size, 'result')} matching '#{keyword}' within #{TextHelper.pluralize(radius, 'mile')} of '#{location}'"
    else
      result = self.find_by_keyword(keyword)
      return result, "#{TextHelper.pluralize(result.size, 'result')} matching '#{keyword}'"
    end
  end

  def self.query_valid?(address)
    if address =~ /(^\d{5}-+)/
      return false
    elsif address =~ /^\d+$/
      if address.length != 5
        return false
      else
        result = address.to_region
        if result.nil?
          return false
        else
          return true
        end
      end
    else
      return true
    end
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
