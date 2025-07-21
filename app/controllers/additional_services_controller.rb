class AdditionalServicesController < ApplicationController
  before_action :set_additional_service, only: [ :show, :edit, :update, :destroy ]

  def index
    @additional_services = AdditionalService.all
  end

  def show
  end

  def new
    @additional_service = AdditionalService.new
  end

  def create
    @additional_service = AdditionalService.new(additional_service_params)

    if @additional_service.save
      redirect_to @additional_service, notice: "Additional service was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @additional_service.update(additional_service_params)
      redirect_to @additional_service, notice: "Additional service was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @additional_service.subscription_services.any? || @additional_service.package_services.any?
      redirect_to additional_services_path, alert: "Cannot delete service with active subscriptions or packages."
    else
      @additional_service.destroy
      redirect_to additional_services_path, notice: "Additional service was successfully deleted."
    end
  end

  private

  def set_additional_service
    @additional_service = AdditionalService.find(params[:id])
  end

  def additional_service_params
    params.require(:additional_service).permit(:name, :price)
  end
end
