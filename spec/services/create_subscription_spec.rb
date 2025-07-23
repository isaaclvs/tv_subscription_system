require 'rails_helper'

RSpec.describe CreateSubscription do
  let(:customer) { create(:customer) }
  let(:plan) { create(:plan) }
  let(:package) { create(:package) }
  let(:additional_service) { create(:additional_service) }

  describe '#call' do
    context 'with valid plan subscription' do
      let(:service) { described_class.new(customer: customer, plan: plan) }

      it 'creates subscription successfully' do
        result = service.call

        expect(result.success?).to be true
        expect(result.subscription).to be_persisted
        expect(result.subscription.customer).to eq customer
        expect(result.subscription.plan).to eq plan
        expect(result.errors).to be_empty
      end

      it 'creates billing automatically' do
        result = service.call
        subscription = result.subscription

        expect(subscription.booklet).to be_present
        expect(subscription.invoices.count).to eq 12
        expect(subscription.accounts.count).to eq 12
      end
    end

    context 'with invalid XOR validation' do
      it 'fails when both plan and package provided' do
        service = described_class.new(customer: customer, plan: plan, package: package)
        result = service.call

        expect(result.success?).to be false
        expect(result.errors).to include("Cannot have both plan and package")
      end

      it 'fails when neither plan nor package provided' do
        service = described_class.new(customer: customer)
        result = service.call

        expect(result.success?).to be false
        expect(result.errors).to include("Must have either plan or package")
      end
    end

    context 'with package subscription' do
      it 'creates subscription with package successfully' do
        service = described_class.new(customer: customer, package: package)
        result = service.call

        expect(result.success?).to be true
        expect(result.subscription).to be_persisted
        expect(result.subscription.package).to eq package
        expect(result.subscription.booklet).to be_present
        expect(result.subscription.invoices.count).to eq 12
      end
    end
  end
end
