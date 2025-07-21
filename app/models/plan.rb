class Plan < ApplicationRecord
  has_many :packages, dependent: :destroy
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
