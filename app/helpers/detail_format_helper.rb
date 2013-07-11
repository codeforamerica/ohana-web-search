module DetailFormatHelper
  
  def has_address(org)
    if org.street_address.present? || 
      org.city.present? ||
      org.state.present? ||
      org.zipcode.present?

      return true
    end
    return false
  end


  def format_address(org)
    address = ""
    if org.street_address.present?
      address += org.street_address
    end

    if org.city.present?
      address += ", #{org.city}"
    end

    if org.state.present?
      address += ", #{org.state}"
    end

    if org.zipcode.present?
      address += ", #{org.zipcode}"
    end

    superscript_ordinals(address)
  end

  # Format phone number as (XXX) XXX-XXXX
  def format_phone(number)

    # return without formatting if number is not present
    if !number.present?
      return
    end

    result = number.gsub(/[^\d]/, '')

    # return without formatting if number is of the wrong length
    if result.length > 10 || result.length < 10
      return number
    end

    "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
  end
end