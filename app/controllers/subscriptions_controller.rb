class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [ :show ]

  def index
    @subscriptions = Subscription.includes(:customer, :plan, :package, :additional_services).all
  end

  def show
  end

  def new
    @subscription_form = SubscriptionForm.new
    load_form_data
  end

  def create
    @subscription_form = SubscriptionForm.new(subscription_form_params)
    
    if @subscription_form.valid?
      result = CreateSubscriptionService.new(
        customer: Customer.find(@subscription_form.customer_id),
        plan: @subscription_form.plan_id.present? ? Plan.find(@subscription_form.plan_id) : nil,
        package: @subscription_form.package_id.present? ? Package.find(@subscription_form.package_id) : nil,
        additional_services: AdditionalService.where(id: @subscription_form.additional_service_ids.reject(&:blank?))
      ).call
      
      if result.success?
        redirect_to result.subscription, notice: "Subscription was successfully created."
      else
        @subscription_form.errors.add(:base, result.errors.join(", "))
        load_form_data
        render :new, status: :unprocessable_entity
      end
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_subscription
    @subscription = Subscription.includes(:customer, :plan, :package, :additional_services, :invoices, :booklet).find(params[:id])
  end

  def load_form_data
    @customers = Customer.all
    @plans = Plan.all
    @packages = Package.all
    @additional_services = AdditionalService.all
  end

  def subscription_form_params
    params.require(:subscription_form).permit(:customer_id, :plan_id, :package_id, additional_service_ids: [])
  end
end

# Form object for subscription creation
class SubscriptionForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :customer_id, :integer
  attribute :plan_id, :integer
  attribute :package_id, :integer
  attribute :additional_service_ids, default: []

  validates :customer_id, presence: true
  validate :must_have_plan_or_package
  validate :cannot_have_both_plan_and_package

  private

  def must_have_plan_or_package
    if plan_id.blank? && package_id.blank?
      errors.add(:base, "Must select either a plan or a package")
    end
  end

  def cannot_have_both_plan_and_package
    if plan_id.present? && package_id.present?
      errors.add(:base, "Cannot select both plan and package")
    end
  end
end
