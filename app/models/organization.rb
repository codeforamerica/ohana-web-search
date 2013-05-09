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
  validates :zipcode, :length => { :minimum => 5, :maximum => 10 }

  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.zipcode}"
  end

  def mapURL
    "http://maps.googleapis.com/maps/api/staticmap?center=#{self.latitude},#{self.longitude}&zoom=15&size=320x240&maptype=roadmap&markers=color:blue%7C#{self.latitude},#{self.longitude}&sensor=false"
  end

  include Geocoder::Model::Mongoid
  geocoded_by :address               # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates
end
