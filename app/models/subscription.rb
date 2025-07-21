class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :plan, optional: true
  belongs_to :package, optional: true
  has_many :subscription_services, dependent: :destroy
  has_many :additional_services, through: :subscription_services
  
  has_many :accounts, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_one :booklet, dependent: :destroy
  
  validate :must_have_plan_or_package
  validate :cannot_have_both_plan_and_package
  validate :additional_services_must_be_unique
  validate :cannot_add_package_services_as_additional
  
  private
  
  def must_have_plan_or_package
    return if plan.present? || package.present?
    
    errors.add(:base, "must have either plan or package")
  end
  
  def cannot_have_both_plan_and_package
    return unless plan.present? && package.present?
    
    errors.add(:base, "cannot have both plan and package")
  end
  
  def additional_services_must_be_unique
    service_ids = additional_services.map(&:id)
    return if service_ids.uniq.size == service_ids.size
    
    errors.add(:additional_services, "cannot have duplicate services")
  end
  
  def cannot_add_package_services_as_additional
    return unless package.present?
    
    package_service_ids = package.additional_services.pluck(:id)
    additional_service_ids = additional_services.pluck(:id)
    
    conflicts = package_service_ids & additional_service_ids
    return if conflicts.empty?
    
    errors.add(:additional_services, "cannot add services that are already in the package")
  end
end
