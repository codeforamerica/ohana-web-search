# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "EHP"
    street_address "1415 Pulgas Avenue"
    zipcode "94114"
    city "East Palo Alto"
    state "CA"
    phone "650-314-5678"
    coordinates [-122.371448, 37.583849]
  end
end
