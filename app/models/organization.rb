class Organization
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :street_address, type: String
  field :zipcode, type: String
  field :city, type: String
  field :state, type: String
  field :url, type: String
  field :email, type: String
  field :phone, type: String
  field :coordinates, type: Array
  field :latitude, type: Float
  field :longitude, type: Float
  field :business_hours, type: Hash
  field :market_match, type: Boolean
  field :schedule, type: String
  field :payments_accepted, type: Array
  field :products_sold, type: Array
  field :keywords, type: Array 

  validates_presence_of :name, :street_address, :city, :state, :zipcode
  extend ValidatesFormattingOf::ModelAdditions
  validates_formatting_of :zipcode, using: :us_zip, message: "Please enter a valid ZIP code"
  validates_formatting_of :phone, using: :us_phone, allow_blank: true, message: "Please enter a valid US phone number"
  validates_formatting_of :url, allow_blank: true
  validates_formatting_of :email, allow_blank: true

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  scope :find_by_keyword,  lambda { |keyword| any_of({name: /\b#{keyword}\b/i}, {keywords: /\b#{keyword}\b/i}) } 
  scope :find_by_location, lambda {|location, radius| near(location, radius) }
  default_scope order_by(:name => :asc)

  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  # Format phone number as (XXX) XXX-XXXX
  def phone_format
    if (self.phone != nil)
      result = self.phone.gsub(/[^\d]/, '')
      return "("+result[0..2]+") "+result[3..5]+"-"+result[6..10]
    end
  end

  def market_match?
    self.market_match
  end
  
  def self.find_by_keyword_and_location(keyword, location, radius)
    if keyword.blank? && location.blank?
      result = self.all
      return result, "Browse all #{result.size} organizations"
    elsif keyword.blank? && location.present?
      result = self.near(location, radius)
      return result, "#{TextHelper.pluralize(result.size, 'organization')} within #{TextHelper.pluralize(radius, 'mile')} of '#{location}'"
    elsif keyword.present? && location.present?
      result = self.find_by_keyword(keyword).find_by_location(location, radius)
      return result, "#{TextHelper.pluralize(result.size, 'organization')} matching '#{keyword}' within #{TextHelper.pluralize(radius, 'mile')} of '#{location}'"
    else
      result = self.find_by_keyword(keyword)
      return result, "#{TextHelper.pluralize(result.size, 'organization')} matching '#{keyword}'"
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
end
