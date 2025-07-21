class PackageService < ApplicationRecord
  belongs_to :package
  belongs_to :additional_service

  validates :package_id, uniqueness: { scope: :additional_service_id }
end
