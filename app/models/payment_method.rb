class PaymentMethod
  include Mongoid::Document
  field :name, type: String
  field :organization_id, type: Integer
  belongs_to :organization
end
