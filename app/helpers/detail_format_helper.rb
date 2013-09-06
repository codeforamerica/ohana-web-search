module DetailFormatHelper

  # Formats ruby field names in CSS convention format
  # by converting underscore delimiting to dash delimiting
  # @param name [String] string to format as
  # @return [String] formatted CSS class name
  def css_class_format(name)
    name.sub '_','-'
  end

  # Renders template partial for detail view
  # @param use_template [Boolean] whether to use the template or a custom partial
  # @param org [Object] a JSON object
  # @param field [String] a field name in org
  # @param title_singular [String] a singular title for name, can be nil
  # @param title_plural [String] a plural title for name, can be nil
  # @param icon [String] a utf-8 icon character for field, can be nil
  # @return rendered partial.
  def insert_template(use_template,org,field,title,icon)
    if use_template
      render :partial => "component/detail/template", :locals => {:org=>org, :field=>field, :title=>title, :icon=>icon}
    else
      render :partial => "component/detail/#{field.to_s}", :locals => {:org=>org, :field=>field, :title=>title, :icon=>icon}
    end
  end

  # List of fields that determine whether or not to show the
  # Service Overview section in the details view
  def service_fields
    [:short_desc,:description,:audience,:service_areas,:how_to_apply,:fees,
      :eligibility,:languages,:accessibility]
  end

  # List of fields that determine whether or not to show the
  # Payments & Products section in the details view
  def market_fields
    [:payments,:market_match,:products]
  end

  # List of fields that determine whether or not to show the
  # Aside section in the details view
  def contact_details
    [:ask_for,:phones,:faxes,:emails,:urls,:address]
  end

  # List of fields that determine whether or not to show the
  # Contact section in the details view
  def contact_fields
    [:ask_for,:phones,:faxes,:emails]
  end

  # Formats address for use in map URLs, image title attributes, etc.
  # @param org [Object] a JSON object
  # @return [String] return comma separated address.
  def address(org)
    "#{org.address["street"]}, #{org.address["city"]}, #{org.address["state"]} #{org.address["zip"]}"
  end

  # Format phone number as (XXX) XXX-XXXX
  # @param number [String] a phone number
  # @return [String] phone number formatted as (XXX) XXX-XXXX or
  # returned without formatting if number is not 10 digits long
  def format_phone(number)
    result = number.gsub(/[^\d]/, '')
    if result.length == 10
      result = "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
    else
      number
    end
  end

  # Adds <sup>XX</sup> around ordinals in string
  # @param [String] string to parse for ordinals
  # @return [String] HTML-safe string containing <sup> elements
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
    string.gsub(/(?<=[0-9])(?:st|nd|rd|th)/){ content_tag(:sup, $&) }.html_safe
  end
end