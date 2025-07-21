FactoryBot.define do
  factory :package do
    name { Faker::Commerce.product_name }
    plan
    price { nil } # Auto-calculated
    
    transient do
      services_count { 1 }
    end
    
    after(:build) do |package, evaluator|
      evaluator.services_count.times do
        service = build(:additional_service)
        package.additional_services << service
      end
    end
  end
end
