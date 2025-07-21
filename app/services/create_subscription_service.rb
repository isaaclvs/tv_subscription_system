require "ostruct"

class CreateSubscriptionService
  attr_reader :customer, :plan, :package, :additional_services, :errors

  def initialize(customer:, plan: nil, package: nil, additional_services: [])
    @customer = customer
    @plan = plan
    @package = package
    @additional_services = Array(additional_services)
    @errors = []
  end

  def call
    return failure_result unless valid?

    create_subscription_and_billing
  end

  private

  def valid?
    validate_xor_plan_package
    validate_no_duplicate_services
    validate_no_package_service_conflicts

    errors.empty?
  end

  def validate_xor_plan_package
    if plan.blank? && package.blank?
      errors << "Must have either plan or package"
    elsif plan.present? && package.present?
      errors << "Cannot have both plan and package"
    end
  end

  def validate_no_duplicate_services
    service_ids = additional_services.map(&:id)
    return if service_ids.uniq.size == service_ids.size

    errors << "Cannot have duplicate additional services"
  end

  def validate_no_package_service_conflicts
    return unless package.present?

    package_service_ids = package.additional_services.pluck(:id)
    additional_service_ids = additional_services.map(&:id)

    conflicts = package_service_ids & additional_service_ids
    return if conflicts.empty?

    errors << "Cannot add services that are already in the package"
  end

  def create_subscription_and_billing
    subscription = nil

    ActiveRecord::Base.transaction do
      subscription = create_subscription
      create_billing_for_subscription(subscription)
    end

    success_result(subscription)
  rescue StandardError => e
    failure_result("Failed to create subscription: #{e.message}")
  end

  def create_subscription
    subscription = Subscription.create!(
      customer: customer,
      plan: plan,
      package: package
    )

    additional_services.each do |service|
      subscription.subscription_services.create!(additional_service: service)
    end

    subscription
  end

  def create_billing_for_subscription(subscription)
    BillingService.new(subscription: subscription).call
  end

  def success_result(subscription)
    OpenStruct.new(success?: true, subscription: subscription, errors: [])
  end

  def failure_result(message = nil)
    all_errors = message ? errors + [ message ] : errors
    OpenStruct.new(success?: false, subscription: nil, errors: all_errors)
  end
end
