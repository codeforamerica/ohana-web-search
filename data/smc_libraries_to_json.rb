require 'open-uri'
require 'nokogiri'
require 'geocoder'
require 'json'

# method that takes as a parameter an address with the format
# "{street_address}, {city}, {state} {zipcode}"
# and returns the lat and long as instance variables
# The geocoder gem is used to convert the address to lat long
def get_lat_long(address)
  result = Geocoder.coordinates(address)
  @latitude = result[0]
  @longitude = result[1]
end

# We'll be using the nokogiri gem to scrape the library details from plsinfo.org
# The website organizes the libraries alphabetically on individual pages
# with URLs that look like "http://plsinfo.org/library-hours/byletter/a"
# The only part of the URL that will be changing is the letter at the end.
# Therefore, we will create a constant for the part of the URL that comes before the letter.
# The letters in the alphabet and the days of the week are also constant, 
# and we'll store them in an array.
ENDPOINT = "http://plsinfo.org/library-hours/byletter".freeze
ALPHABET = ("a".."z").to_a.freeze
DAYS     = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]

# We'll be storing each library's attributes (name, address, phone, etc.) in a Hash
libraries_data = Hash.new

ALPHABET.each do |letter|
  html      = Nokogiri::HTML open("#{ENDPOINT.dup}/#{letter}")
  libraries = html.css(".views-row")
 
  libraries.each do |library|
    name            = library.at_css(".views-field-title .field-content").text
    street_address  = library.at_css(".street-address").text
    city            = library.at_css(".locality").text
    state           = library.at_css(".region").text
    zipcode         = library.at_css(".postal-code").text
    phone           = library.css(".country-name")[1].text.split(":")[1]

    libraries_data[name]                    = Hash.new
    libraries_data[name]['name']            = name
    libraries_data[name]['street_address']  = street_address
    libraries_data[name]['city']            = city
    libraries_data[name]['state']           = state
    libraries_data[name]['zipcode']         = zipcode
    libraries_data[name]['phone']           = phone
    address = "#{street_address}, #{city}, #{state} #{zipcode}"

    get_lat_long(address)
    # The geocoder gem pings Google's API, which limits request rates
    # Therefore, we'll pause for half a second in between address lookups
    sleep(0.5)

    libraries_data[name]['longitude'] = @longitude
    libraries_data[name]['latitude'] = @latitude
    libraries_data[name]['type'] = "Library"

    i = 6
    DAYS.each do |day|
      cells = library.css("td")
      opens_at = [[cells.at(i), cells.at(i+1)].join(""), cells.at(i+2)].join(" ")
      closes_at = [[cells.at(i+3), cells.at(i+4)].join(""), cells.at(i+5)].join(" ")
      libraries_data[name]["#{day}_opens_at"] = opens_at
      libraries_data[name]["#{day}_closes_at"] = closes_at
      i += 8
    end
  end
end

# convert the Hash to json and save to a file called "libaries_data.json"
File.open("libraries_data.json","w") do |f|
  f.write(libraries_data.to_json)
end