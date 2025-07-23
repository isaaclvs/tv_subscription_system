require 'rails_helper'

RSpec.describe Billing do
  let(:customer) { create(:customer) }
  let(:plan) { create(:plan, price: 50.00) }
  let(:subscription) { create(:subscription, customer: customer, plan: plan) }

  describe '#call' do
    subject { described_class.new(subscription: subscription) }

    context 'with valid subscription' do
      it 'creates billing successfully' do
        result = subject.call

        expect(result.success?).to be true
        expect(result.invoices_count).to eq 12
        expect(result.accounts_count).to eq 12
        expect(result.booklet).to be_present
      end

      it 'creates correct due dates' do
        travel_to Date.new(2024, 1, 15) do
          subscription.update!(created_at: Time.current)
          result = subject.call

          # First invoice should be for February (next month after creation)
          first_invoice = subscription.invoices.order(:due_date).first
          expect(first_invoice.due_date).to eq Date.new(2024, 2, 15)
          expect(first_invoice.month_year).to eq "2024-02"

          # Last invoice should be for January next year
          last_invoice = subscription.invoices.order(:due_date).last
          expect(last_invoice.due_date).to eq Date.new(2025, 1, 15)
          expect(last_invoice.month_year).to eq "2025-01"
        end
      end

      it 'calculates correct amounts' do
        result = subject.call

        subscription.invoices.each do |invoice|
          expect(invoice.total_amount).to eq plan.price
        end

        expect(result.booklet.total_amount).to eq plan.price * 12
      end
    end

    context 'with invalid subscription' do
      it 'fails when billing already exists' do
        create(:booklet, subscription: subscription)
        result = subject.call

        expect(result.success?).to be false
        expect(result.errors).to include("Billing already exists for this subscription")
      end
    end

    context 'date calculations' do
      it 'creates invoices for next 12 months' do
        travel_to Date.new(2024, 6, 15) do
          subscription.update!(created_at: Time.current)
          result = subject.call

          expect(subscription.invoices.count).to eq 12

          # Check first and last invoice dates
          first_invoice = subscription.invoices.order(:due_date).first
          last_invoice = subscription.invoices.order(:due_date).last

          expect(first_invoice.due_date).to eq Date.new(2024, 7, 15)
          expect(last_invoice.due_date).to eq Date.new(2025, 6, 15)
        end
      end
    end
  end
end
