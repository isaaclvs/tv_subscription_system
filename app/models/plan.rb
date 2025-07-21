class Plan < ApplicationRecord
  has_many :packages, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
