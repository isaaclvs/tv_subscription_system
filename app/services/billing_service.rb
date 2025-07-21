require "ostruct"

class BillingService
  attr_reader :subscription, :errors

  def initialize(subscription:)
    @subscription = subscription
    @errors = []
  end

  def call
    return failure_result unless valid?

    create_billing_structure
  end

  private

  def valid?
    unless subscription.persisted?
      errors << "Subscription must be persisted"
      return false
    end

    if subscription.booklet.present?
      errors << "Billing already exists for this subscription"
      return false
    end

    true
  end

  def create_billing_structure
    ActiveRecord::Base.transaction do
      create_twelve_months_billing
      create_booklet
    end

    success_result
  rescue StandardError => e
    failure_result("Failed to create billing: #{e.message}")
  end

  def create_twelve_months_billing
    12.times do |month_offset|
      due_date = calculate_due_date(month_offset)
      month_year = due_date.strftime("%Y-%m")

      accounts = create_accounts_for_month(due_date)
      create_invoice_for_month(month_year, due_date, accounts)
    end
  end

  def calculate_due_date(month_offset)
    base_date = subscription.created_at.to_date
    next_month = base_date.next_month

    next_month + month_offset.months
  end

  def create_accounts_for_month(due_date)
    accounts = []

    # Account for plan or package
    if subscription.plan.present?
      accounts << create_account(subscription.plan, due_date)
    elsif subscription.package.present?
      accounts << create_account(subscription.package, due_date)
    end

    # Accounts for additional services
    subscription.additional_services.each do |service|
      accounts << create_account(service, due_date)
    end

    accounts
  end

  def create_account(item, due_date)
    subscription.accounts.create!(
      item: item,
      amount: item.price,
      due_date: due_date
    )
  end

  def create_invoice_for_month(month_year, due_date, accounts)
    total_amount = accounts.sum(&:amount)

    subscription.invoices.create!(
      month_year: month_year,
      total_amount: total_amount,
      due_date: due_date
    )
  end

  def create_booklet
    total_amount = subscription.invoices.sum(:total_amount)

    subscription.create_booklet!(
      total_amount: total_amount
    )
  end

  def success_result
    OpenStruct.new(
      success?: true,
      booklet: subscription.booklet,
      invoices_count: subscription.invoices.count,
      accounts_count: subscription.accounts.count,
      errors: []
    )
  end

  def failure_result(message = nil)
    all_errors = message ? errors + [ message ] : errors
    OpenStruct.new(success?: false, booklet: nil, errors: all_errors)
  end
end
