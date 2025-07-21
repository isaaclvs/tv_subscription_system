require 'rails_helper'

RSpec.describe "Edge Cases", type: :request do
  let(:customer) { create(:customer) }
  let(:plan) { create(:plan) }
  let(:package) { create(:package) }
  let(:service) { create(:additional_service) }

  describe "Basic controller functionality" do
    it "can create a customer with valid data" do
      expect {
        post "/customers", params: {
          customer: { name: "Valid Customer", age: 25 }
        }
      }.to change(Customer, :count).by(1)

      expect(response).to redirect_to(Customer.last)
    end

    it "can create a plan with valid data" do
      expect {
        post "/plans", params: {
          plan: { name: "Valid Plan", price: 50.00 }
        }
      }.to change(Plan, :count).by(1)

      expect(response).to redirect_to(Plan.last)
    end

    it "can create an additional service with valid data" do
      expect {
        post "/additional_services", params: {
          additional_service: { name: "Valid Service", price: 10.00 }
        }
      }.to change(AdditionalService, :count).by(1)

      expect(response).to redirect_to(AdditionalService.last)
    end

    it "can list all entities" do
      get "/customers"
      expect(response).to have_http_status(:success)

      get "/plans"
      expect(response).to have_http_status(:success)

      get "/additional_services"
      expect(response).to have_http_status(:success)

      get "/packages"
      expect(response).to have_http_status(:success)

      get "/subscriptions"
      expect(response).to have_http_status(:success)
    end
  end
end
