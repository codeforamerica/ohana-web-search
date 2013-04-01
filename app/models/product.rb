class Product
  include Mongoid::Document
  field :name, type: String
  field :organization_id, type: Integer
end
