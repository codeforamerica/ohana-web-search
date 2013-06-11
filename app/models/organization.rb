class Organization
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :street_address, type: String
  field :zipcode, type: String
  field :city, type: String
  field :state, type: String
  field :urls, type: Array
  field :emails, type: Array
  field :phone, type: String
  field :faxes, type: Array
  field :ttys, type: Array
  field :service_hours, type: String
  field :phones, type: Array
  field :coordinates, type: Array
  field :latitude, type: Float
  field :longitude, type: Float
  field :business_hours, type: Hash
  field :market_match, type: Boolean
  field :schedule, type: String
  field :payments_accepted, type: Array
  field :products_sold, type: Array
  field :languages_spoken, type: Array
  field :keywords, type: Array 
  field :target_group, type: String
  field :eligibility_requirements, type: String
  field :fees, type: String
  field :how_to_apply, type: String
  field :service_wait, type: String
  field :transportation_availability, type: String
  field :accessibility, type: String
  field :services_provided, type: String

  validates_presence_of :name
  
  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zipcode, using: :us_zip, allow_blank: true, message: "Please enter a valid ZIP code"
  validates_formatting_of :phone, using: :us_phone, allow_blank: true, message: "Please enter a valid US phone number"
  validates :emails, array: { format: { with: /.+@.+\..+/i, message: "Please enter a valid email" } }
  validates :urls,   array: { format: 
                            { with: /(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i, 
                              message: "Please enter a valid URL" } }

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  #after_validation :geocode          # auto-fetch coordinates. disable only when using the load_data rake task

  scope :find_by_keyword,  lambda { |keyword| any_of({name: /\b#{keyword}\b/i}, {keywords: /\b#{keyword}\b/i}) } 
  scope :find_by_location, lambda {|location, radius| near(location, radius) }
  default_scope order_by(:name => :asc)

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

  # URL to static map for map image on org details.
  def mapURL
    "http://maps.googleapis.com/maps/api/staticmap?center=#{self.latitude},#{self.longitude}&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C#{self.latitude},#{self.longitude}&sensor=false"
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
  def self.query(params)
    @client = Ohanakapa.new

    # return all results if keyword and location are blank
    if params[:keyword].blank? && params[:location].blank?
      return @client.organizations(params)
    end

    response = @client.query(params)
  end

end
