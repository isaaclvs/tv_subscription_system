require 'rails_helper'

RSpec.describe "AdditionalServices", type: :request do
  let(:service) { create(:additional_service) }
  let(:valid_attributes) { { name: "Premium Service", price: 19.90 } }
  let(:invalid_attributes) { { name: "", price: -1 } }

  describe "GET /additional_services" do
    it "returns success" do
      get "/additional_services"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /additional_services/:id" do
    it "returns success" do
      get "/additional_services/#{service.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /additional_services" do
    it "creates service" do
      expect {
        post "/additional_services", params: { additional_service: valid_attributes }
      }.to change(AdditionalService, :count).by(1)
    end

    it "handles invalid data" do
      post "/additional_services", params: { additional_service: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /additional_services/:id" do
    it "updates service" do
      patch "/additional_services/#{service.id}", params: { additional_service: { name: "Updated" } }
      expect(response).to redirect_to(additional_service_path(service))
    end
  end

  describe "DELETE /additional_services/:id" do
    it "destroys service" do
      service_to_delete = create(:additional_service)
      expect {
        delete "/additional_services/#{service_to_delete.id}"
      }.to change(AdditionalService, :count).by(-1)
    end
  end
end
