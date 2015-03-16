module DetailFormatHelper
  # List of fields that determine whether or not to show the
  # Service Overview section in the details view
  def service_fields
    [:audience, :service_areas, :application_process, :fees,
     :eligibility, :languages, :accessibility]
  end

  # List of fields that determine whether or not to show the
  # Contact section in the details view
  def location_contact_fields
    [:urls, :emails, :phones]
  end

  # Strips http:// or https:// from URL
  # @param number [String] a url
  # @return [String] The url without http:// or https://
  def format_url(url)
    url.gsub(%r{^(https?:\/\/)}, '')
  end

  # Generates HTML snippet for a contact's details (title and/or department).
  # @param contact [Hash] A contact's hash of details.
  # @return [HTML] The formatted contact details snippet.
  def contact_details_for(contact)
    if contact.title.present? && contact.department.present?
      return contact_title_and_department_for(contact)
    end
    return contact_title_for(contact) if contact.title.present?
    return contact_department_for(contact) if contact.department.present?
  end

  # Generates HTML snippet for a contact's title and department.
  # @param contact [Hash] A contact's hash of details.
  # @return [HTML] The formatted contact details snippet.
  def contact_title_and_department_for(contact)
    contact_title_for(contact) + ', ' + contact_department_for(contact)
  end

  # Generates HTML snippet for a contact's title.
  # @param contact [Hash] A contact's hash of details.
  # @return [HTML] The formatted contact details snippet.
  def contact_title_for(contact)
    content_tag :span, class: 'contact-title' do
      contact.title
    end
  end

  # Generates HTML snippet for a contact's details (title and/or department).
  # @param contact [Hash] A contact's hash of details.
  # @return [HTML] The formatted contact details snippet.
  def contact_department_for(contact)
    content_tag :span, class: 'contact-department' do
      contact.department
    end
  end

  # Adds <sup>XX</sup> around ordinals in string.
  # @param string [String] to parse for ordinals.
  # @return [String] HTML-safe string containing <sup> elements.
  #
  # The regex finds all occurrences of ordinal numbers, matching
  # only the "st", "nd", "rd", and "th" portion. The gsub method
  # accepts a block, in which we pass the replacement text using
  # the global regex variable "$&", which represents the matched text.
  # In plain english, we are looking for all occurrences of
  # "st", "nd", "rd", and "th" that are preceded by a number, and then
  # we replace them with "<sup>#{the text that was matched}</sup>".
  # "content_tag(:sup, $&)" is Rails shorthand for "<sup>#{$&}</sup>".
  #
  # For security purposes, in case the original string contains malicious
  # content, such as a <script>, we first apply the Rails html_escape method,
  # which converts "<" and ">" to "&lt;" and "&gt;", hence preventing any
  # scripts from actually running. Then, once we add the <sup> tags to our
  # safe string, we can declare this new string to be html_safe, since the
  # only html we are not escaping are the <sup> tags, and what's in between
  # the tags is controlled by us.
  def superscript_ordinals(string)
    string = html_escape(string).to_str
    string.gsub(/(?<=[0-9])(?:st|nd|rd|th)/) { content_tag(:sup, $&) }.html_safe
  end

  # @param date [String] A date string, such as '1970-01-01'
  # @return [String] The year of incorporation.
  def incorporated_year_for(date)
    Date.parse(date).strftime('%Y')
  end
end
