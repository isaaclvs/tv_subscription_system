FactoryBot.define do
  factory :plan do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 20.0..100.0) }
  end
end
