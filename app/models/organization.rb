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
  field :monday_opens_at, type: Time
  field :monday_closes_at, type: Time
  field :tuesday_opens_at, type: Time
  field :tuesday_closes_at, type: Time
  field :wednesday_opens_at, type: Time
  field :wednesday_closes_at, type: Time
  field :thursday_opens_at, type: Time
  field :thursday_closes_at, type: Time
  field :firday_opens_at, type: Time
  field :friday_closes_at, type: Time
  field :saturday_opens_at, type: Time
  field :saturday_closes_at, type: Time
  field :sunday_opens_at, type: Time
  field :sunday_closes_at, type: Time
  field :type, type: String

  has_many :payment_methods, dependent: :destroy
  validates_presence_of :name, :street_address, :city, :state, :zipcode, :phone
  validates :zipcode, :length => { :minimum => 5, :maximum => 10 }
end
