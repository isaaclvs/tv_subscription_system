FactoryBot.define do
  factory :invoice do
    subscription { nil }
    month_year { "MyString" }
    total_amount { "9.99" }
    due_date { "2025-07-21" }
  end
end
