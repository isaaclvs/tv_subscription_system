class CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :edit, :update, :destroy ]

  def index
    @customers = Customer.includes(:subscriptions).all
  end

  def show
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: "Customer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Customer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.subscriptions.any?
      redirect_to customers_path, alert: "Cannot delete customer with active subscriptions."
    else
      @customer.destroy
      redirect_to customers_path, notice: "Customer was successfully deleted."
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :age)
  end
end
