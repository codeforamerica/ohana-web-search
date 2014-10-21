module AddressFormatHelper
  # Formats street address for use in map URLs, image title attributes, etc.
  # @param address [Object] A JSON object containing address data.
  # @return [String] A comma separated street address.
  def street_address_for(address)
    return address.street_1 if address.street_2.blank?
    "#{address.street_1}, #{address.street_2}"
  end

  # Formats full address for use in map URLs, image title attributes, etc.
  # Full address includes street, city, state and postal code.
  # @param address [Object] A JSON object containing address data.
  # @return [String] A comma separated full address.
  def full_address_for(address)
    "#{street_address_for(address)}, #{address.city}, #{address.state} #{address.postal_code}"
  end
end
