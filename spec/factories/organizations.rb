# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "Burlingame, Easton Branch"
    street_address "1800 Easton Drive"
    zipcode "94010"
    city "Burlingame"
    state "CA"
    phone "650-314-5678"
    coordinates [-122.371448, 37.583849]
    keywords ["library"]
  end
end
