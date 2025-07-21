FactoryBot.define do
  factory :subscription do
    customer
    plan
    package { nil }
    
    trait :with_package do
      plan { nil }
      package
    end
  end
end
