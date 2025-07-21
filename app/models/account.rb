class Account < ApplicationRecord
  belongs_to :subscription
  belongs_to :item, polymorphic: true

  validates :item_type, presence: true, inclusion: { in: %w[Plan Package AdditionalService] }
  validates :item_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :due_date, presence: true
  validates :subscription_id, uniqueness: { scope: [ :item_type, :item_id, :due_date ] }
end
