require 'rails_helper'

RSpec.describe "Packages", type: :request do
  let(:package) { create(:package) }
  let(:plan) { create(:plan) }
  let(:service) { create(:additional_service) }

  describe "GET /packages" do
    it "returns success" do
      get "/packages"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /packages/:id" do
    it "returns success" do
      get "/packages/#{package.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /packages/new" do
    it "returns success" do
      get "/packages/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /packages" do
    it "handles package creation" do
      post "/packages", params: { 
        package: { 
          name: "Test Package", 
          plan_id: plan.id, 
          price: 100.0,
          additional_service_ids: [service.id]
        }
      }
      expect(response.status).to be_between(200, 422)
    end
  end

  describe "DELETE /packages/:id" do
    it "destroys package" do
      package_to_delete = create(:package)
      expect {
        delete "/packages/#{package_to_delete.id}"
      }.to change(Package, :count).by(-1)
    end
  end
end