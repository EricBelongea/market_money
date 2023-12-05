FactoryBot.define do
  factory :market do
    name { Faker::Market.name }
    street { Faker::Market.street_name }
    city { Faker::Market.city }
    county { "#{Faker::Market.city} County" }
    state { Faker::Market.state }
    zip { Faker::Market.zip }
    lat { Faker::Market.latitude }
    lon { Faker::Market.longitude }
  end
end

FactoryBot.define do
  factory :vendor do
    name { Faker::Vendor.name }
    description { Faker::Vendor.sentence }
    contact_name { Faker::Vendor.name }
    contact_phone { Faker::Vendor.phone_number }
    credit_accepted { Faker::Vendor.boolean }
  end
end