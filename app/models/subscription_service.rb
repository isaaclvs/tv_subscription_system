class SubscriptionService < ApplicationRecord
  belongs_to :subscription
  belongs_to :additional_service

  validates :subscription_id, uniqueness: { scope: :additional_service_id }
end
