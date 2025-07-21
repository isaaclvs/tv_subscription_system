require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:customer) { create(:customer) }
  let(:plan) { create(:plan) }
  let(:package) { create(:package) }

  describe 'XOR validation' do
    it 'is valid with plan only' do
      subscription = Subscription.new(customer: customer, plan: plan)
      expect(subscription).to be_valid
    end

    it 'is valid with package only' do
      subscription = Subscription.new(customer: customer, package: package)
      expect(subscription).to be_valid
    end

    it 'is invalid with both plan and package' do
      subscription = Subscription.new(customer: customer, plan: plan, package: package)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:base]).to include("cannot have both plan and package")
    end

    it 'is invalid with neither plan nor package' do
      subscription = Subscription.new(customer: customer)
      expect(subscription).not_to be_valid
      expect(subscription.errors[:base]).to include("must have either plan or package")
    end
  end

  describe 'associations' do
    it 'belongs to customer' do
      subscription = create(:subscription, customer: customer, plan: plan)
      expect(subscription.customer).to eq customer
    end

    it 'can belong to plan' do
      subscription = create(:subscription, customer: customer, plan: plan)
      expect(subscription.plan).to eq plan
    end

    it 'can have additional services' do
      subscription = create(:subscription, customer: customer, plan: plan)
      expect(subscription.additional_services).to respond_to(:<<)
    end
  end
end
