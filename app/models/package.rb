class Package < ApplicationRecord
  belongs_to :plan
  has_many :package_services, dependent: :destroy
  has_many :additional_services, through: :package_services
  has_many :subscriptions, dependent: :destroy
  
  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }, allow_nil: true
  validate :must_have_at_least_one_service
  
  before_save :calculate_price_if_blank
  
  private
  
  def must_have_at_least_one_service
    errors.add(:additional_services, "must have at least one service") if additional_services.empty?
  end
  
  def calculate_price_if_blank
    return if price.present?
    
    self.price = plan.price + additional_services.sum(&:price)
  end
end
