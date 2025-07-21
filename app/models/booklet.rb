class Booklet < ApplicationRecord
  belongs_to :subscription
  has_many :invoices, through: :subscription
  has_many :accounts, through: :subscription
  
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :subscription_id, uniqueness: true
end
