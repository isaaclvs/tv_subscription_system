class AdditionalService < ApplicationRecord
  has_many :package_services, dependent: :destroy
  has_many :packages, through: :package_services
  has_many :subscription_services, dependent: :destroy
  has_many :subscriptions, through: :subscription_services
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
