class CustomersController < ApplicationController
  def index
    @customers = Customer.includes(:subscriptions).all
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
