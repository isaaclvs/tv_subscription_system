class PlansController < ApplicationController
  before_action :set_plan, only: [ :show, :edit, :update, :destroy ]

  def index
    @plans = Plan.all
  end

  def show
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to @plan, notice: "Plan was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: "Plan was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @plan.subscriptions.any? || @plan.packages.any?
      redirect_to plans_path, alert: "Cannot delete plan with active subscriptions or packages."
    else
      @plan.destroy
      redirect_to plans_path, notice: "Plan was successfully deleted."
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :price)
  end
end
