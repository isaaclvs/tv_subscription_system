FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    age { rand(18..80) }
  end
end
