class BusinessHour
  include Mongoid::Document
  field :day, type: Integer
  field :opens_at, type: Time
  field :closes_at, type: Time
  field :organization_id, type: Integer
end
