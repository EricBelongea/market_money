FactoryBot.define do
  factory :market_vendor do
    market_id { Faker::Number.number }
    vendor_id { Faker::Number.number }
  end
end
