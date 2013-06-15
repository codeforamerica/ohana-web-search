class Organization
  include Mongoid::Document
  field :accessibility_options, type: Array
  field :agency, type: String
  field :ask_for, type: Array
  field :city, type: String
  field :coordinates, type: Array
  field :description, type: String
  field :eligibility_requirements, type: String
  field :emails, type: Array
  field :faxes, type: Array
  field :fees, type: String
  field :funding_sources, type: Array
  field :how_to_apply, type: String
  field :keywords, type: Array
  field :languages_spoken, type: Array
  field :leaders, type: Array
  field :market_match, type: Boolean
  field :name, type: String
  field :payments_accepted, type: Array
  field :phones, type: Array
  field :products_sold, type: Array
  field :schedule, type: String
  field :service_areas, type: Array
  field :service_hours, type: String
  field :service_wait, type: String
  field :services_provided, type: String
  field :state, type: String
  field :street_address, type: String
  field :target_group, type: String
  field :transportation_availability, type: String
  field :ttys, type: Array
  field :urls, type: Array
  field :zipcode, type: String

  validates_presence_of :name

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address

  scope :find_by_keyword,  lambda { |keyword| any_of({name: /\b#{keyword}\b/i}, {keywords: /\b#{keyword}\b/i}, {agency: /\b#{keyword}\b/i}) }
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
    "http://maps.googleapis.com/maps/api/staticmap?center=#{self.coordinates[1]},#{self.coordinates[0]}&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C#{self.coordinates[1]},#{self.coordinates[0]}&sensor=false"
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
