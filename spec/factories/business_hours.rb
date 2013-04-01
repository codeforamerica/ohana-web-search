# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :business_hour do
    day 1
    opens_at "2013-04-01 15:45:18"
    closes_at "2013-04-01 15:45:18"
    organization_id 1
  end
end
