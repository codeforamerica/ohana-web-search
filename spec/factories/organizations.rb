# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "EHP"
    description "Provides food, clothing, furniture, computer room"
    street_address "1415 Pulgas Avenue"
    zipcode "94114"
    city "East Palo Alto"
    state "CA"
    url "http://www.ehp.org"
    email "info@ehp.org"
    phone "650-314-5678"
    latitude 1.5
    longitude 1.5
    type "Food Pantry"
  end
end
