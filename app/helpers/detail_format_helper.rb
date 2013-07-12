module DetailFormatHelper
  
  # Checks for presence of any of the address fields
  # @param org [Object] the format type, `:text` or `:html`
  # @return [Boolean] return true if any address field is present, otherwise return false.
  def has_address?(org)
    if org["street_address"].present? || 
      org["city"].present? ||
      org["state"].present? ||
      org["zipcode"].present?

      return true
    end
    return false
  end


  def format_address(org)
    array = Array.new

    if org["street_address"].present?
      array.push org['street_address']
    end

    if org["city"].present?
      array.push org['city']
    end

    if org["state"].present?
      array.push org['state']
    end

    if org["zipcode"].present?
      array.push org['zipcode']
    end

    address = array.join(", ")
    superscript_ordinals(address)
  end

  # Format phone number as (XXX) XXX-XXXX
  def format_phone(number)

    # return without formatting if number is not 9 digits long
    result = number.gsub(/[^\d]/, '')
    if result.length == 10
      result = "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
    else
      number
    end
  end

  # Adds <sup>XX</sup> around ordinals in string
  # @param [String] string to parse for ordinals
  # @return [String] HTML-safe string possibly containing <sup> elements
  def superscript_ordinals(string)
    val = ordinal_parse(string,'st')
    val = ordinal_parse(val,'nd')
    val = ordinal_parse(val,'rd')
    val = ordinal_parse(val,'th')
    val.html_safe
  end

  private
  # parse ordinals and add <sup> element
  def ordinal_parse(string, ordinal)
    exp = '(^.*\d)('+ordinal+')(\b.*)'
    regex = Regexp.new exp
    fname = string.split(regex)

    parsed = ''
    fname.each do |snippet|

      if snippet == ordinal
        snippet = "<sup>#{ordinal}</sup>"
      end

      parsed += snippet

    end

    parsed
  end

end