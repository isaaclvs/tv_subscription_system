require 'rails_helper'

RSpec.describe "Plans", type: :request do
  let(:plan) { create(:plan) }
  let(:valid_attributes) { { name: "Plano Premium", price: 49.90 } }
  let(:invalid_attributes) { { name: "", price: -1 } }

  describe "GET /plans" do
    it "returns http success" do
      create_list(:plan, 3)
      get "/plans"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /plans/:id" do
    it "returns http success" do
      get "/plans/#{plan.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /plans/new" do
    it "returns http success" do
      get "/plans/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /plans/:id/edit" do
    it "returns http success" do
      get "/plans/#{plan.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /plans" do
    context "with valid parameters" do
      it "creates a new Plan" do
        expect {
          post "/plans", params: { plan: valid_attributes }
        }.to change(Plan, :count).by(1)
      end

      it "redirects to the created plan" do
        post "/plans", params: { plan: valid_attributes }
        expect(response).to redirect_to(plan_path(Plan.last))
      end

      it "sets a success flash message" do
        post "/plans", params: { plan: valid_attributes }
        expect(flash[:notice]).to eq("Plan was successfully created.")
      end
    end

    context "with invalid parameters" do
      it "does not create a plan" do
        expect {
          post "/plans", params: { plan: invalid_attributes }
        }.to_not change(Plan, :count)
      end

      it "renders the new template with errors" do
        post "/plans", params: { plan: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /plans/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Plano Updated", price: 59.90 } }

      it "updates the plan" do
        patch "/plans/#{plan.id}", params: { plan: new_attributes }
        plan.reload
        expect(plan.name).to eq("Plano Updated")
        expect(plan.price).to eq(59.90)
      end

      it "redirects to the plan" do
        patch "/plans/#{plan.id}", params: { plan: new_attributes }
        expect(response).to redirect_to(plan_path(plan))
      end
    end

    context "with invalid parameters" do
      it "renders edit template with errors" do
        patch "/plans/#{plan.id}", params: { plan: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /plans/:id" do
    context "when plan has no dependencies" do
      it "destroys the plan" do
        plan_to_delete = create(:plan)
        expect {
          delete "/plans/#{plan_to_delete.id}"
        }.to change(Plan, :count).by(-1)
      end

      it "redirects to plans index" do
        delete "/plans/#{plan.id}"
        expect(response).to redirect_to(plans_path)
      end

      it "sets success flash message" do
        delete "/plans/#{plan.id}"
        expect(flash[:notice]).to eq("Plan was successfully deleted.")
      end
    end

    context "when plan has subscriptions" do
      let!(:subscription) { create(:subscription, plan: plan) }

      it "does not destroy the plan" do
        expect {
          delete "/plans/#{plan.id}"
        }.to_not change(Plan, :count)
      end

      it "redirects with error message" do
        delete "/plans/#{plan.id}"
        expect(response).to redirect_to(plans_path)
        expect(flash[:alert]).to eq("Cannot delete plan with active subscriptions or packages.")
      end
    end

    context "when plan has packages" do
      let!(:package) { create(:package, plan: plan) }

      it "does not destroy the plan" do
        expect {
          delete "/plans/#{plan.id}"
        }.to_not change(Plan, :count)
      end

      it "redirects with error message" do
        delete "/plans/#{plan.id}"
        expect(response).to redirect_to(plans_path)
        expect(flash[:alert]).to eq("Cannot delete plan with active subscriptions or packages.")
      end
    end
  end
end
