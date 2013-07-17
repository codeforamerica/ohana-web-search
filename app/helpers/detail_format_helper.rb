module DetailFormatHelper

  # Formats ruby field names in CSS convention format 
  # by converting underscore delimiting to dash delimiting
  # @param name [String] string to format as 
  # @return [String] formatted CSS class name
  def css_class_format(name)
    name.sub '_','-'
  end

  # Renders template partial for detail view
  # @param org [Object] a JSON object
  # @param field [String] a field name in org
  # @param title [String] a title for name, can be nil
  # @param icon [String] a utf-8 icon character for field, can be nil
  # @return rendered partial.
  def insert_template(use_template,org,field,title,icon)
    if use_template
      render :partial => "component/detail/template", :locals => {:org=>org, :field=>field, :title=>title,:icon=>icon}
    else
      render :partial => "component/detail/#{field}", :locals => {:org=>org, :field=>field, :title=>title,:icon=>icon}
    end

  end

  # Checks for presence of any fields on an object
  # @param org [Object] a JSON object
  # @param array [Array] an array of strings
  # @return [Boolean] return true if any field in array is present in org,
  # otherwise return false.
  def has_field?(obj, array)
    val = false
    array.each { |field| obj.fetch(field).present? ? val = true : nil }
    val
  end

  # Groups all address fields into an array
  # @return [Array] list of address field names as strings.
  def address_fields
    ["street_address", "city", "state", "zipcode"]
  end

  # Formats address for use in map URLs, image title attributes, etc.
  # @param org [Object] a JSON object
  # @return [String] return comma separated address.
  def address(org)
    "#{org.street_address}, #{org.city}, #{org.state} #{org.zipcode}"
  end

  # Generate static map URL
  # @param org [Object] a JSON object
  # @return [String] return static map URL if coordinates are present.
  def map_url(org)
    if org.coordinates.present?
      "http://api.tiles.mapbox.com/v3/examples.map-rlxntei0/pin-s("+
        "#{org.coordinates[0]},#{org.coordinates[1]})/#{org.coordinates[0]}"+
        ",#{org.coordinates[1]},15/400x300.png"
    end
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

  # Format a timestamp, such as "2013-07-04T04:27:19Z", in a reader friendly fashion,
  # for example "Thursday, 4 July 2013 at 4:27:19 AM"
  # Note that it doesn't include the timezone offset in the output.
  # @param timestamp [Sting] a timestamp string
  # @return [String] formatted timestamp
  def format_timestamp(timestamp)
    timeobj = DateTime.parse(timestamp)
    timeobj.strftime("%A, %e %B %Y at %l:%M:%S %p")
  end

  # Adds <sup>XX</sup> around ordinals in string
  # @param [String] string to parse for ordinals
  # @return [String] HTML-safe string containing <sup> elements

  # The regex finds all occurrences of ordinal numbers, matching
  # only the "st", "nd", "rd", and "th" portion. The gsub method
  # accepts a block, in which we pass the replacement text using
  # the global regex variable "$&", which represents the matched text.
  # In plain english, we are looking for all occurrences of
  # "st", "nd", "rd", and "th" that are preceded by a number, and then
  # we replace them with "<sup>#{the text that was matched}</sup>".
  # "content_tag(:sup, $&)" is Rails shorthand for "<sup>#{$&}</sup>".

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