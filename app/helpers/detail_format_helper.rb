module DetailFormatHelper

  # Checks for presence of any of the address fields
  # @param org [Object] a JSON object
  # @return [Boolean] return true if any address field is present,
  # otherwise return false.
  def has_address?(org)
    array = [org.street_address, org.city, org.state, org.zipcode]
    array.any?
  end

  def address(org)
    "#{org.street_address}, #{org.city}, #{org.state} #{org.zipcode}"
  end

  def map_url(org)
    if org.coordinates.present?
      "http://api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-s("+
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