module PhoneFormatHelper
  # Format phone number as (XXX) XXX-XXXX
  # @param number [String] a phone number
  # @return [String] phone number formatted as (XXX) XXX-XXXX or
  # returned without formatting if number is not 10 digits long
  def format_phone(number)
    result = number.gsub(/[^\d]/, '')
    if result.length == 10
      "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
    else
      number
    end
  end

  # Choose a font-awesome icon string for a particular phone type.
  # @param type [String] The value for a location's phone_type field.
  # @return [String] The font-awesome icon string.
  def phone_icon_for(type)
    return 'fa fa-phone-square' if type == 'voice' || type == 'hotline'
    return 'fa fa-print' if type == 'fax'
    return 'fa fa-tty' if type == 'tty'
    return 'fa fa-mobile' if type == 'sms'
  end

  # Choose either a fax or telephone schema.org-style microdata itemsprop type.
  # @param type [String] The value for a location's phone_type field.
  # @return [String] Microdata for fax or telephone numbers.
  def phone_microdata_for(type)
    type == 'fax' ? 'faxNumber' : 'telephone'
  end

  # Choose the first voice or hotline phone number from a list of phones.
  # @param phones [Array] List of phone hashes.
  # @return [String] The first voice or hotline phone number
  #   or nil if none are found.
  def first_voice_or_hotline_phone_for(phones)
    phones.find { |phone| voice_or_hotline?(phone) }
  end

  # Whether a phone is of the voice or hotline type.
  # @param phone [Hash] Phone details.
  # @return [Boolean] True if the phone is a voice or hotline, false otherwise.
  def voice_or_hotline?(phone)
    phone.number_type == 'voice' || phone.number_type == 'hotline'
  end
end
