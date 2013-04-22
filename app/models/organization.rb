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
  field :latitude, type: Float
  field :longitude, type: Float
  field :business_hours, type: Hash
  field :type, type: String

  validates_presence_of :name, :street_address, :city, :state, :zipcode, :phone
  validates :zipcode, :length => { :minimum => 5, :maximum => 10 }
end
