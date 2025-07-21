require 'rails_helper'

RSpec.describe "Customers", type: :request do
  let(:customer) { create(:customer) }
  let(:valid_attributes) { { name: "João Silva", age: 25 } }
  let(:invalid_attributes) { { name: "", age: 16 } }

  describe "GET /customers" do
    it "returns http success" do
      create_list(:customer, 3)
      get "/customers"
      expect(response).to have_http_status(:success)
    end

    it "displays all customers" do
      customer1 = create(:customer, name: "João", age: 25)
      customer2 = create(:customer, name: "Maria", age: 30)
      get "/customers"
      expect(response.body).to include("João")
      expect(response.body).to include("Maria")
    end
  end

  describe "GET /customers/:id" do
    it "returns http success" do
      get "/customers/#{customer.id}"
      expect(response).to have_http_status(:success)
    end

    it "displays customer details" do
      get "/customers/#{customer.id}"
      expect(response.body).to include(customer.name)
      expect(response.body).to include(customer.age.to_s)
    end
  end

  describe "GET /customers/new" do
    it "returns http success" do
      get "/customers/new"
      expect(response).to have_http_status(:success)
    end

    it "displays new customer form" do
      get "/customers/new"
      expect(response.body).to include("New Customer")
      expect(response.body).to include("form")
    end
  end

  describe "GET /customers/:id/edit" do
    it "returns http success" do
      get "/customers/#{customer.id}/edit"
      expect(response).to have_http_status(:success)
    end

    it "displays edit customer form" do
      get "/customers/#{customer.id}/edit"
      expect(response.body).to include("Edit Customer")
      expect(response.body).to include(customer.name)
    end
  end

  describe "POST /customers" do
    context "with valid parameters" do
      it "creates a new Customer" do
        expect {
          post "/customers", params: { customer: valid_attributes }
        }.to change(Customer, :count).by(1)
      end

      it "redirects to the created customer" do
        post "/customers", params: { customer: valid_attributes }
        expect(response).to redirect_to(customer_path(Customer.last))
      end

      it "sets a success flash message" do
        post "/customers", params: { customer: valid_attributes }
        expect(flash[:notice]).to eq("Customer was successfully created.")
      end
    end

    context "with invalid parameters" do
      it "does not create a customer" do
        expect {
          post "/customers", params: { customer: invalid_attributes }
        }.to_not change(Customer, :count)
      end

      it "renders the new template with errors" do
        post "/customers", params: { customer: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
      end
    end
  end

  describe "PATCH /customers/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "João Updated", age: 35 } }

      it "updates the customer" do
        patch "/customers/#{customer.id}", params: { customer: new_attributes }
        customer.reload
        expect(customer.name).to eq("João Updated")
        expect(customer.age).to eq(35)
      end

      it "redirects to the customer" do
        patch "/customers/#{customer.id}", params: { customer: new_attributes }
        expect(response).to redirect_to(customer_path(customer))
      end
    end

    context "with invalid parameters" do
      it "renders edit template with errors" do
        patch "/customers/#{customer.id}", params: { customer: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("error")
      end
    end
  end

  describe "DELETE /customers/:id" do
    context "when customer has no subscriptions" do
      it "destroys the customer" do
        customer_to_delete = create(:customer)
        expect {
          delete "/customers/#{customer_to_delete.id}"
        }.to change(Customer, :count).by(-1)
      end

      it "redirects to customers index" do
        delete "/customers/#{customer.id}"
        expect(response).to redirect_to(customers_path)
      end
    end

    context "when customer has subscriptions" do
      let!(:subscription) { create(:subscription, customer: customer) }

      it "does not destroy the customer" do
        expect {
          delete "/customers/#{customer.id}"
        }.to_not change(Customer, :count)
      end

      it "redirects with error message" do
        delete "/customers/#{customer.id}"
        expect(response).to redirect_to(customers_path)
        expect(flash[:alert]).to eq("Cannot delete customer with active subscriptions.")
      end
    end
  end
end
