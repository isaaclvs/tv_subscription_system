FactoryBot.define do
  factory :additional_service do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 5.0..50.0) }
  end
end
