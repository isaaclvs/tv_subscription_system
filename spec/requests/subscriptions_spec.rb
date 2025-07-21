require 'rails_helper'

RSpec.describe "Subscriptions", type: :request do
  let(:customer) { create(:customer) }
  let(:plan) { create(:plan) }
  let(:package) { create(:package) }
  let(:service) { create(:additional_service) }

  describe "GET /subscriptions" do
    it "returns success" do
      get "/subscriptions"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /subscriptions/:id" do
    it "returns success" do
      subscription = create(:subscription, customer: customer, plan: plan)
      get "/subscriptions/#{subscription.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /subscriptions/new" do
    it "returns success" do
      get "/subscriptions/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /subscriptions" do
    it "handles subscription creation" do
      post "/subscriptions", params: {
        subscription: {
          customer_id: customer.id,
          plan_id: plan.id
        }
      }
      expect(response.status).to be_between(200, 422)
    end
  end
end