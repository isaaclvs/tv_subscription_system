class Customer < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }
end
