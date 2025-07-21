class Invoice < ApplicationRecord
  belongs_to :subscription
  has_many :accounts, ->(invoice) { where(due_date: invoice.due_date) }, through: :subscription
  
  validates :month_year, presence: true, format: { with: /\A\d{4}-\d{2}\z/ }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :due_date, presence: true
  validates :subscription_id, uniqueness: { scope: :month_year }
end
