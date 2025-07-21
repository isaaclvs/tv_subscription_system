FactoryBot.define do
  factory :account do
    subscription { nil }
    item_type { "MyString" }
    item_id { 1 }
    amount { "9.99" }
    due_date { "2025-07-21" }
  end
end
